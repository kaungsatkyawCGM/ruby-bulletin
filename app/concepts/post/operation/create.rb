module Post::Operation
  class Create < Trailblazer::Operation
    class Present < Trailblazer::Operation
      step Model(Post, :new)
      step Contract::Build(constant: Post::Contract::Create)
    end
    step Nested(Present)
    step Contract::Validate(key: :post)
    step :create!

    def create!(options, params:, **)
      @post = Post.new
      @post.title = params[:post][:title]
      @post.description = params[:post][:description]
      @post.public_flag = params[:post][:public_flag]
      @post.image_data = params[:post][:image_data]
      @post.created_user_id = options['current_user_id']
      @post.updated_user_id = options['current_user_id']
      if @post.save
        true
      end
    end
  end
end
