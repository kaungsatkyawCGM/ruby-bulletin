module Post::Operation
  class PostList < Trailblazer::Operation
    step :get_post_list

    def get_post_list(options, **)
      # public only or not
      if options['all_flag']
        @posts = Post.all
      else
        @posts = Post.where(public_flag: 1)
      end

      # for profile
      @posts = @posts.where(created_user_id: options['user_id']) unless options['user_id'].nil?

      # for search
      @posts = @posts.where('title LIKE ?', "%#{options['search'].downcase}%") unless options['search'].nil?

      # for filter
      unless options['filter'].nil? || options['filter'].blank?
        @filer_user = User.find_by(id: options['filter'])

        @posts = @filer_user.posts
      end

      options['posts'] = @posts.order(post_id: :desc)
    end
  end
end
