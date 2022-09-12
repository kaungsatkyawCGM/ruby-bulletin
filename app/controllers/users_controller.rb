class UsersController < ApplicationController
  before_action :authorized_and_admin?, except: %i[change_password action_change_password show edit update]
  before_action :already_login?, only: %i[change_password action_change_password]
  def index
    @users = UserService.getAllUserList(current_user_obj[:id])
  end

  def user_list
    @users = UserService.getAllUserList(current_user_obj[:id])

    render json: {users: @users}
  end

  def show
    @user = UserService.getUserById(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @is_save = UserService.save(@user, current_user_obj.id)
    if @is_save
      flash[:notice] = Messages::CREATED_SUCCESS
      redirect_to users_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    if (current_user_obj[:role] == Constants::USER_ROLE) && (current_user_obj[:id].to_s != params[:id])
      redirect_to user_path(params[:id]) and return
    end

    @user = UserService.getUserById(params[:id])
    @user_form = @user
  end

  def update
    @user = UserService.getUserById(params[:id])
    @user_form = UserService.getUserById(params[:id])
    @is_updated = UserService.update(@user_form, current_user_obj.id, user_params)
    if @is_updated
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user = UserService.getUserById(params[:id])
    UserService.deleteUser(@user)
    flash[:notice] = Messages::DELETED_SUCCESS
    redirect_to users_path, status: :see_other
  end

  def download_csv
    @users = UserService.getAllUserList(current_user_obj[:id])
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
    @change_password_form = ChangePasswordForm.new(current_user_obj)
  end

  def action_change_password
    @change_password_form = ChangePasswordForm.new(current_user_obj)

    if @change_password_form.submit(params[:change_password_form])
      redirect_to users_path, notice: Messages::CHANGE_PASSWORD_SUCCESS
    else
      render :change_password
    end
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
        @user = UserService.create(row.merge(created_by: current_user_id, updated_by: current_user_id))
        raise @user.errors.objects.first.full_message unless @user.valid?
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

  def user_edit_params
    params.require(:user).permit(:name, :email, :role, :phone)
  end
end
