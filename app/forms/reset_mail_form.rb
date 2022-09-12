class ResetMailForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  validates :email, presence: { message: Validations::REQUIRED },
                    format: { with: Constants::VALID_EMAIL_REGEX, message: Validations::VALID_EMAIL_REGEX }
  validate :verify_user_exist
  attr_accessor :email, :token

  def create_data(params)
    self.email = params[:email]
    if valid?
      @password_reset = PasswordReset.new
      @password_reset.token = SecureRandom.hex(10)
      @password_reset.sent_at = Time.now.utc
      @password_reset.email = email
      PasswordResetService.save(@password_reset)
      ResetPasswordMailer.new_reset_password_email(@password_reset).deliver_later
      return true
    end
    false
  end

  def verify_user_exist
    unless UserService.findByEmail(email).present?
      errors.add :verify_user_exist, :invalid, message: Messages::INVALID_EMAIL
    end
  end

  def persisted?
    false
  end
end
