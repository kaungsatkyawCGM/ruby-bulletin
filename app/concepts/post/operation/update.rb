module Post::Operation
  class Update < Trailblazer::Operation
    class Present < Trailblazer::Operation
      step Model(Post, :find_by, :post_id)
      step Contract::Build(constant: Post::Contract::Update)
    end
    step Nested(Present)
    step :assign_current_user!
    step Contract::Validate(key: :post)
    step :update!

    def assign_current_user!(options, params:, **)
      params[:post][:updated_user_id] = options['current_user_id']
    end

    def update!(options, params:, model:, **)
      @post_params = params.require(:post).permit(:title, :description, :public_flag, :image_data, :clear)
      if (!params[:post][:image_data].nil? && !model.nil? && model.image_data.attached?) || params[:post][:clear] == 'true'
        model.image_data.purge
      end

      model.update(@post_params.except(:clear))
      true
    end
  end
end