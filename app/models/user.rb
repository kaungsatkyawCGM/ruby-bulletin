class User < ApplicationRecord
  has_many :posts, class_name: 'Post', inverse_of: :user, foreign_key: 'created_user_id', dependent: :delete_all

  before_save :prepare_data

  validates :name, presence: { message: Validations::REQUIRED },
                   length: { maximum: 255, too_long: Validations::MAXIMUN }
  validates :email, presence: { message: Validations::REQUIRED }, length: { maximum: 255, too_long: Validations::MAXIMUN },
                    format: { with: Constants::VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, confirmation: true, presence: { message: Validations::REQUIRED }, length: { minimum: 8, maximum: 20, too_short: Validations::MINIMUN, too_long: Validations::MAXIMUN }, on: :create
  validates :phone, numericality: { message: Validations::VALID_INTEGER }, length: { minimum: 10, maximum: 15, too_short: Validations::MINIMUN, too_long: Validations::MAXIMUN }, allow_blank: true
  validates :role, inclusion: { in: %w[1 0] }

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
