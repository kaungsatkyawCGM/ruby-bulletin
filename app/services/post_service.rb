class PostService
  class << self
    def getAllPosts(all_flag, search, filter, user_id)
      @posts = PostRepository.getAllPosts(all_flag, search, filter, user_id)
    end

    def createPost(post)
      @isSavePost = PostRepository.createPost(post)
    end

    def getPost(post_id)
      @post = PostRepository.getPost(post_id)
    end

    def update(post, params)
      PostRepository.update(post, params)
    end
  end
end
