class User < ApplicationRecord
  before_save :prepare_data

  validates :name, presence: true, length: { maximum: 255}
  validates :email, presence: true, length: { maximum: 255},
                      format: { with: Constants::VALID_EMAIL_REGEX  },
                      uniqueness: { case_sensitive: false }
  validates :password, confirmation: true, presence: true,on: :create
  validates :phone, numericality: true, length: { minimum: 10, maximum: 15 }, allow_blank: true
  validates :role, inclusion: { in: %w(1 0)}, on: :create_user

  has_secure_password

  def self.to_csv
    headers = Constants::EXPORT_USER_CSV_HEADER
    CSV.generate(headers: true) do |csv|
      csv << headers
      all.each do |user|
        csv << [user.id, user.name, user.email, user.phone, user.role == "1" ? "Admin" : "User", user.created_at.strftime("%d/%m/%Y")]
      end
    end
  end

  private

  def prepare_data
    self.email = email.downcase
    self.created_by = 1
    self.updated_by = 1
  end
end
