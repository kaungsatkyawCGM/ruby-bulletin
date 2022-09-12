class AuthController < ApplicationController
  def login
    @login_form = LoginForm.new(User.new)

    redirect_to posts_path unless session[:user_id].nil?
  end

  def action_login
    @login_form = LoginForm.new(login_params)

    if params[:login_form][:email].blank? || params[:login_form][:password].blank?
      flash[:error] = Messages::EMAIL_AND_PASSWORD_REQUIRE_VALIDATION
    else
      user = UserService.findByEmail(params[:login_form][:email].downcase)
      if user&.authenticate(params[:login_form][:password])
        session[:user_id] = user.id
        redirect_to users_path and return
      else
        flash[:error] = Messages::INVALID_LOGIN
      end
    end
    render :login
  end

  def register
    @user = User.new

    redirect_to users_path unless session[:user_id].nil?
  end

  def action_register
    params[:user][:role] = 0
    @user = User.new(user_params)
    @is_save = UserService.save(@user, nil)
    if @is_save
      user = UserService.findByEmail(params[:user][:email].downcase)
      if user&.authenticate(params[:user][:password])
        session[:user_id] = user.id
        redirect_to users_path and return
      end
    end
    render :register, status: :unprocessable_entity
  end

  def logout
    session.delete(:user_id)
    @current_user = nil
    redirect_to login_path
  end

  def reset_password_mail
    @reset_mail_form = ResetMailForm.new
  end

  def sent_reset_password_mail
    @reset_mail_form = ResetMailForm.new

    if @reset_mail_form.create_data(sent_reset_mail_params)
      redirect_to :login, notice: Messages::EMAIL_SENT_SUCCESS
    else
      render 'auth/reset_password_mail'
    end
  end

  def password_reset
    token = params[:token].to_s
    @password_reset = PasswordResetService.findByToken(token)
    @change_password_form = ChangePasswordForm.new(User.new)

    redirect_to login_path and return unless @password_reset&.password_token_valid?
  end

  def action_password_reset
    token = params[:token].to_s
    @password_reset = PasswordResetService.findByToken(token)
    redirect_to login_path and return unless @password_reset&.password_token_valid?

    @user = UserService.findByEmail(@password_reset[:email])

    @change_password_form = ChangePasswordForm.new(@user)

    if @change_password_form.reset_password(reset_password_params)
      redirect_to login_path, notice: Messages::CHANGE_PASSWORD_SUCCESS
    else
      render :password_reset
    end
  end

  private

  def login_params
    params.require(:login_form).permit(:email, :password)
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role, :phone, :created_by, :updated_by)
  end

  def sent_reset_mail_params
    params.require(:reset_mail_form).permit(:email)
  end

  def reset_password_params
    params.require(:change_password_form).permit(:password, :password_confirmation)
  end
end
