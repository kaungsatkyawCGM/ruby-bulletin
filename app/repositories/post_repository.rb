class PostRepository
  class << self
    def getAllPosts(all_flag, search, filter, user_id)
      # public only or not
      @posts = if all_flag
                 Post.all
               else
                 Post.where(public_flag: 1)
               end

      # for profile
      @posts = @posts.where(created_user_id: user_id) unless user_id.nil?

      # for search
      @posts = @posts.where('title LIKE ?', "%#{search.downcase}%") unless search.nil?

      # for filter
      unless filter.nil? || filter.blank?
        @filer_user = User.find_by(id: filter)

        @posts = @filer_user.posts
      end

      @posts.order(post_id: :desc)
    end

    def createPost(post)
      @isSavePost = post.save
    end

    def getPost(post_id)
      @post = Post.find(post_id)
    end

    def update(post, params)
      post.update(params)
    end
  end
end
