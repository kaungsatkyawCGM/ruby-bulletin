class User < ApplicationRecord
  has_many :posts, class_name: 'Post', inverse_of: :user, foreign_key: 'created_user_id', dependent: :delete_all

  attr_accessor :old_password

  before_save :prepare_data

  has_secure_password

  def self.to_csv
    headers = Constants::EXPORT_USER_CSV_HEADER
    CSV.generate(headers: true) do |csv|
      csv << headers
      all.each do |user|
        csv << [user.id, user.name, user.email, user.phone, user.role == '1' ? 'Admin' : 'User',
                user.created_at.strftime('%d/%m/%Y')]
      end
    end
  end

  private

  def prepare_data
    self.email = email.downcase
  end
end
