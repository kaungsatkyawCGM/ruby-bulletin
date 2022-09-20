class UsersController < ApplicationController
  before_action :authorized_and_admin?, except: %i[change_password action_change_password show edit update]
  before_action :already_login?, only: %i[change_password action_change_password]
  def index
    run User::Operation::UserList, user_id: current_user_obj[:id], params: nil do |result|
      @users = result[:users]
    end
  end

  def user_list
    run User::Operation::UserList, user_id: current_user_obj[:id], params: params do |result|
      @users = result[:users]
    end

    @slice_users = @users.slice(params[:start].to_i, params[:length].to_i)

    render json: {
      data: {
        users: @slice_users
      },
      draw: (params['draw'].to_i || 0) + 1,
      recordsTotal: @users.count,
      recordsFiltered: @users.count,
      ids: @users
    }
  end

  def show
    run User::Operation::Update::Present do |result|
      @user = result[:user]
    end

    if result.failure?
      not_found
    end
  end

  def new
    run User::Operation::Create::Present
  end

  def create
    run User::Operation::Create, current_user_id: current_user_obj.id do |result|
      flash[:notice] = Messages::CREATED_SUCCESS
      return redirect_to users_path
    end

    render :new, status: :unprocessable_entity
  end

  def edit
    if (current_user_obj[:role] == Constants::USER_ROLE) && (current_user_obj[:id].to_s != params[:id])
      redirect_to user_path(params[:id]) and return
    end

    run User::Operation::Update::Present do |result|
      @user = result[:user]
    end

    if result.failure?
      not_found
    end
  end

  def update
    run User::Operation::Update::Present do |result|
      @user = result[:user]
    end

    if current_user_obj[:role] == Constants::ADMIN_ROLE
      @user_params = user_params
    else
      @user_params = user_params.except(:role)
    end

    run User::Operation::Update, current_user_id: current_user_obj.id, user_params: @user_params do |result|
      return redirect_to @user, notice: Messages::UPDATED_SUCCESS
    end
    render :edit, status: :unprocessable_entity
  end

  def destroy
    run User::Operation::Destroy do |_|
      flash[:notice] = Messages::DELETED_SUCCESS
      redirect_to users_path, status: :see_other
    end
  end

  def download_csv
    run User::Operation::UserList, user_id: current_user_obj[:id], params: nil do |result|
      @users = result[:users]
    end
    respond_to do |format|
      format.html
      format.csv { send_data @users.to_csv, filename: 'user_list.csv' }
    end
  end

  def import_csv
    if params[:file].nil?
      redirect_to users_path, alert: Messages::REQUIRE_FILE
    elsif !File.extname(params[:file]).eql?('.csv')
      redirect_to users_path, alert: Messages::WRONG_FILE_TYPE
    else
      error_msg = UsersHelper.check_header(Constants::IMPORT_USER_CSV_HEADER, params[:file])
      if error_msg.present?
        redirect_to users_path, alert: error_msg
      else
        import(params[:file], current_user_obj.id)
      end
    end
  end

  def change_password
    run User::Operation::ChangePassword::Present
  end

  def action_change_password
    run User::Operation::ChangePassword, current_user_obj: current_user_obj do |result|
      return redirect_to users_path, notice: Messages::CHANGE_PASSWORD_SUCCESS
    end
    flash[:error] = result[:verify_old_password] if result.failure? && result[:verify_old_password].present?

    render :change_password
  end

  private

  def import(file, current_user_id)
    # like try catch

    # transition
    ActiveRecord::Base.transaction do
      CSV.foreach(file.path, headers: true, encoding: 'iso-8859-1:utf-8', row_sep: :auto,
                             header_converters: :symbol) do |row|
        row = row.to_hash
        row[:role] = (row[:role].downcase == 'admin' ? '0' : '1')

        @parameters = row.merge(created_by: current_user_id, updated_by: current_user_id)
        result = User::Operation::Import.call(params: @parameters)

        raise result[:"contract.default"].errors.messages.values.first.first if result.failure?
      end
      redirect_to users_path, notice: Messages::UPLOAD_SUCCESS
    end
  rescue StandardError => e
    flash[:alert] = e.message
    redirect_to users_path and return
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role, :phone)
  end
end
