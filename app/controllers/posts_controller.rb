class PostsController < ApplicationController
  def index
    @post = PostForm.new(Post.new)
    @users = UserService.getAllUserList((current_user_obj.present? ? current_user_obj[:id] : nil), nil)
    @posts = PostService.getAllPosts(false, params[:search], params[:filter], nil)
  end

  def create
    if logged_in?
      @post = PostForm.new(Post.new)

      if @post.createData(post_params, current_user_obj.id)
        flash[:notice] = Messages::POST_CREATED_SUCCESS
        success_path
      else
        all_flag = false
        failure_path
      end
    else
      render :login_path
    end
  end

  def profile_post
    @user = UserService.getUserById(params[:id])
    @post = PostForm.new(Post.new)
    all_flag = false

    all_flag = true if params[:id].to_i == session[:user_id]

    @posts = PostService.getAllPosts(all_flag, params[:search], nil, params[:id])

    render 'users/post_list'
  end

  def destroy
    @post = PostService.getPost(params[:post_id])
    @post.destroy
    flash[:notice] = Messages::POST_DELETED_SUCCESS
    redirect_to user_posts_path(current_user_obj)
  end

  def edit
    @post = PostForm.new(PostService.getPost(params[:id]))
  end

  def update
    params[:post_form][:updated_user_id] ||= current_user_obj.id
    @post = PostForm.new(PostService.getPost(params[:post_id]))

    if @post.updateData(post_params)
      flash[:notice] = Messages::POST_UPDATED_SUCCESS
      redirect_to user_posts_path(current_user_obj)
    else
      render :edit
    end
  end

  private

  def post_params
    params.require(:post_form).permit(:title, :description, :public_flag, :image_data, :clear)
  end

  def success_path
    redirect_to user_posts_path and return if params[:id].present?

    redirect_to posts_path and return
  end

  def failure_path
    if params[:id].present?
      @user = UserService.getUserById(params[:id])
      all_flag = true if params[:id].to_i == session[:user_id]

      @posts = PostService.getAllPosts(all_flag, nil, params[:id], nil)
      render 'users/post_list'
    else
      @users = UserService.getAllUserList((current_user_obj.present? ? current_user_obj[:id] : nil), nil)
      @posts = PostService.getAllPosts(all_flag, nil, nil, nil)
      render 'posts/index'
    end
  end
end
