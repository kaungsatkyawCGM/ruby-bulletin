class AuthController < ApplicationController
  def login
    @login_form = LoginForm.new

    if !session[:user_id].nil?
      redirect_to users_path and return
    end
  end

  def action_login
    if params[:login_form][:email].blank? && params[:login_form][:password].blank?
      flash[:error] = Messages::EMAIL_AND_PASSWORD_REQUIRE_VALIDATION
    elsif params[:login_form][:email].blank? && params[:login_form][:password] != nil
      flash[:error] = Messages::EMAIL_REQUIRE_VALIDATION
    elsif params[:login_form][:email] != nil && params[:login_form][:password].blank?
      flash[:error] = Messages::PASSWORD_REQUIRE_VALIDATION
    else 
      user = UserService.findByEmail(params[:login_form][:email].downcase)
      if user && user.authenticate(params[:login_form][:password])
        session[:user_id] = user.id
        redirect_to users_path and return
      else
        flash[:error] = Messages::INVALID_LOGIN
      end
    end
    redirect_to login_path
  end

  def register
    @user = User.new

    if !session[:user_id].nil?
      redirect_to users_path and return
    end
  end

  def action_register
    @user = User.new(user_params)
    if @user.save
      user = UserService.findByEmail(params[:user][:email].downcase)
      if user && user.authenticate(params[:user][:password])
        session[:user_id] = user.id
        redirect_to users_path and return
      else
        render :register, status: :unprocessable_entity
      end
    else
      render :register, status: :unprocessable_entity
    end
  end

  def logout
    session.delete(:user_id)
    @current_user = nil
    redirect_to login_path
  end

  private

  def login_params
    params.require(:login_form).permit(:email, :password)
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role, :phone, :created_by, :updated_by)
  end
end
