class PostsController < ApplicationController
  before_action :already_login?, only: %i[new create]

  def index
    run User::Operation::UserList, user_id: (current_user_obj.present? ? current_user_obj[:id] : nil), params: nil do |result|
      @users = result[:users]
    end
    run Post::Operation::PostList, all_flag: false, search: params[:search], filter: params[:filter], user_id: nil do |result|
      @posts = result[:posts]
    end
  end

  def create
    if logged_in?
      run Post::Operation::Create, current_user_id: current_user_obj.id, profile_id: params[:id] do |result|
        flash[:notice] = Messages::POST_CREATED_SUCCESS
        success_path
      end
      if result.failure?
        all_flag = false
        if params[:id].present?
          failture_operations
          failure_path
        else
          render :new
        end
      end
    else
      render :login_path
    end
  end

  def new
    run Post::Operation::Create::Present
  end

  def profile_post
    run User::Operation::UserList, profile_id: params[:id] do |result|
      @user = result[:user]
    end

    all_flag = false
    all_flag = true if params[:id].to_i == session[:user_id]

    run Post::Operation::PostList, all_flag: all_flag, search: params[:search], filter: nil, user_id: params[:id] do |result|
      @posts = result[:posts]
    end

    run Post::Operation::Create::Present
    render 'users/post_list'
  end

  def destroy
    run Post::Operation::Destroy do |_|
      return redirect_to user_posts_path(current_user_obj), notice: Messages::POST_DELETED_SUCCESS
    end
  end

  def edit
    unless logged_in? && (current_user_obj.posts.pluck(:post_id).include? params[:post_id].to_i)
      redirect_to posts_path and return
    end
    run Post::Operation::Update::Present
  end

  def update
    run Post::Operation::Update, current_user_id: current_user_obj.id do |result|
      flash[:notice] = Messages::POST_UPDATED_SUCCESS
      redirect_to user_posts_path(current_user_obj)
    end
    if result.failure?
      render :edit
    end
  end

  private
  def success_path
    redirect_to user_posts_path and return if params[:id].present?

    redirect_to posts_path and return
  end

  def failure_path
    if params[:id].present?
      render 'users/post_list'
    end
  end

  def failture_operations
    if params[:id].present?
      run User::Operation::UserList, profile_id: params[:id] do |result|
        @user = result[:user]
      end
      all_flag = true if params[:id].to_i == session[:user_id]
      run Post::Operation::PostList, all_flag: all_flag, search: nil, filter: nil, user_id: params[:id] do |result|
        @posts = result[:posts]
      end
      run Post::Operation::Create do |result|
      end
    end
  end
end
