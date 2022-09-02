class ApplicationController < ActionController::Base
  def current_user_obj
    @current_user ||= User.find(session[:user_id])
  end

  def logged_in?
    !!current_user_obj
  end

  def authorized?
    redirect_to login_path unless logged_in?
  end

  def logged_in_as_admin?
    @user = User.where("users.id = ? and users.role = '1'", session[:user_id])
    Rails.logger.info(session[:user_id])

    if @user.blank?
      return false
    else
      return true
    end

  end

  def authorized_and_admin?
    redirect_to login_path unless logged_in_as_admin?
  end

  helper_method :current_user, :logged_in?, :authorized_and_admin?
end
