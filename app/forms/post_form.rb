class PostForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  validates :title, :description, presence: { message: Validations::REQUIRED },
                                  length: { maximum: 255, too_long: Validations::MAXIMUN }
  validates :public_flag, inclusion: { in: %w[true false] }

  attr_accessor :post_id, :title, :description, :public_flag, :image_data

  def initialize(post)
    @post = post

    self.post_id = @post.post_id
    self.title = @post.title
    self.description = @post.description
    self.public_flag = @post.public_flag
    self.image_data = @post.image_data
  end

  def updateData(params)
    self.title = params[:title]
    self.description = params[:description]
    self.public_flag = params[:public_flag]

    if valid?
      # delete image
      if (!params[:image_data].nil? && !@post.nil? && @post.image_data.attached?) || params[:clear] == 'true'
        @post.image_data.purge
      end

      PostService.update(@post, params.except(:clear))
      true
    else
      false
    end
  end

  def createData(params, user_id)
    self.title = params[:title]
    self.description = params[:description]
    self.public_flag = params[:public_flag]

    if valid?
      @post.title = title
      @post.description = description
      @post.public_flag = public_flag
      @post.image_data = params[:image_data]
      @post.created_user_id = user_id
      @post.updated_user_id = user_id
      PostService.createPost(@post)
      true
    else
      false
    end
  end

  def persisted?
    false
  end
end
