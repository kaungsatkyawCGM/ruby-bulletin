class ApplicationController < ActionController::Base
  def current_user_obj
    run User::Operation::CurrentUser, user_id: session[:user_id] do |result|
      return result[:current_user]
    end
    return false
  end

  def logged_in?
    !!current_user_obj
  end

  def authorized?
    redirect_to login_path unless logged_in?
  end

  def logged_in_as_admin?
    run User::Operation::CurrentUser, user_id: session[:user_id], admin_flg: true do |result|
      @user = result[:current_user]
    end

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

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  helper_method :current_user_obj, :logged_in?, :authorized_and_admin?, :already_login?, :not_found
end
