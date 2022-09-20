module Post::Contract
  class Create < Reform::Form
    property :post_id
    property :title
    property :description
    property :public_flag
    property :image_data

    validates :title, :description, presence: { message: ValidationMessages::REQUIRED },
                                  length: { maximum: 255, too_long: ValidationMessages::MAXIMUN }
    validates :public_flag, inclusion: { in: %w[true false] }
  end
end