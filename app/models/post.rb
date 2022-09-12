class Post < ApplicationRecord
  has_one_attached :image_data
  belongs_to :user, class_name: 'User', foreign_key: 'created_user_id', inverse_of: :posts
end
