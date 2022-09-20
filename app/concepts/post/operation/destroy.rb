module Post::Operation
  class Destroy < Trailblazer::Operation
    step Model(Post, :find_by, :post_id)
    step :delete!

    def delete!(options, model:, **)
      model.destroy
    end
  end
end