class UsersController < ApplicationController
  # require "#{Rails.root}/app/services/user_service"
  
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

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = Messages::DELETED_SUCCESS_MSG
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
      redirect_to users_path, notice: Messages::REQUIRE_FILE
    elsif !File.extname(params[:file]).eql?(".csv")
      redirect_to users_path, notice: Messages::WRONG_FILE_TYPE
    else
      error_msg = UsersHelper.check_header(Constants::IMPORT_USER_CSV_HEADER, params[:file])
      if error_msg.present?
        redirect_to users_path, notice: error_msg
      else
          User.import(params[:file], current_user.id)
          redirect_to posts_path, notice: Messages::UPLOAD_SUCCESSFUL
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role, :phone, :created_by, :updated_by)
  end
end
