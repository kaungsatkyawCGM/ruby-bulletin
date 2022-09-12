class ApplicationController < ActionController::Base
  def current_user_obj
    @current_user ||= UserService.getUserById(session[:user_id])
  end

  def logged_in?
    !!current_user_obj
  end

  def authorized?
    redirect_to login_path unless logged_in?
  end

  def logged_in_as_admin?
    @user = UserService.getAdminUser(session[:user_id])

    if @user.blank?
      false
    else
      true
    end
  end

  def authorized_and_admin?
    redirect_to login_path unless logged_in_as_admin?
  end

  def already_login?
    redirect_to login_path unless logged_in?
  end

  helper_method :current_user_obj, :logged_in?, :authorized_and_admin?, :already_login?
end
