class UsersController < ApplicationController
  # before_action :authorized_and_admin?
  
  def index
    @users = UserService.getAllUserList
    @users = @users.reorder('id ASC')
  end

  def show
    @user = UserService.getUserById(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "User account has been created"
      redirect_to users_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = Messages::DELETED_SUCCESS
    redirect_to users_path, status: :see_other
  end

  def download_pdf
    @users = UserService.getAllUserList
    respond_to do |format|
      format.html
      format.csv { send_data @users.to_csv,  :filename => "user_list.csv" }
    end
  end

  def import_csv
    if (params[:file].nil?)
      redirect_to users_path, alert: Messages::REQUIRE_FILE
    elsif !File.extname(params[:file]).eql?(".csv")
      redirect_to users_path, alert: Messages::WRONG_FILE_TYPE
    else
      error_msg = UsersHelper.check_header(Constants::IMPORT_USER_CSV_HEADER, params[:file])
      if error_msg.present?
        redirect_to users_path, alert: error_msg
      else
        import(params[:file], 1)
      end
    end
  end

  private

  def import(file, current_user_id)
    #like try catch
    begin
      #transition
      ActiveRecord::Base.transaction do
        CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8', row_sep: :auto, header_converters: :symbol) do |row|
          Rails.logger.info(row.to_hash[:role])
          row = row.to_hash
          row[:role] = (row[:role].downcase == "admin" ? "0" : "1")
          @user = User.create(row.merge(created_by: 1, updated_by: 1))
          unless @user.valid?
            raise @user.errors.objects.first.full_message
          end
        end
        redirect_to users_path, notice: Messages::UPLOAD_SUCCESS
      end
    rescue Exception => e
      flash[:alert] = e.message
      redirect_to users_path and return
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role, :phone, :created_by, :updated_by)
  end
end
