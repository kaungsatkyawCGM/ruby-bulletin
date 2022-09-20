class AuthController < ApplicationController
  def login
    redirect_to posts_path unless session[:user_id].nil?
    run Auth::Operation::Login::Present
  end

  def action_login
    run Auth::Operation::Login do |result|
      session[:user_id] = result[:user][:id]
      redirect_to posts_path and return
    end

    if result.failure? && result[:invalid_login]
      flash[:error] = Messages::INVALID_LOGIN
    else
      flash[:error] = Messages::EMAIL_AND_PASSWORD_REQUIRE_VALIDATION
    end
    render :login
  end

  def register
    redirect_to posts_path unless session[:user_id].nil?
    run Auth::Operation::Register::Present
  end

  def action_register
    run Auth::Operation::Register do |result|
      session[:user_id] = result[:user][:id]
      redirect_to posts_path and return
    end

    render :register if result.failure?
  end

  def logout
    session.delete(:user_id)
    @current_user = nil
    redirect_to login_path
  end

  def reset_password_mail
    run Auth::Operation::ResetPasswordMail::Present
  end

  def sent_reset_password_mail
    run Auth::Operation::ResetPasswordMail do |result|
      redirect_to :login, notice: Messages::EMAIL_SENT_SUCCESS
    end

    render :reset_password_mail if result.failure?
  end

  def password_reset
    run Auth::Operation::Password do |result|
      @password_reset = result[:password_reset]
    end
    run Auth::Operation::ResetPassword::Present

    redirect_to login_path and return unless @password_reset&.password_token_valid?
  end

  def action_password_reset
    run Auth::Operation::ResetPassword do |result|
      redirect_to login_path, notice: Messages::CHANGE_PASSWORD_SUCCESS
    end
    render :login_path and return if result.failure? && result[:no_valid_token]

    render :password_reset if result.failure?
  end
end
