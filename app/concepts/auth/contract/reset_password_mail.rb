module Auth::Contract
  class ResetPasswordMail < Reform::Form
    property :email

    validates :email, presence: { message: ValidationMessages::REQUIRED },
                      format: { with: Constants::VALID_EMAIL_REGEX, message: ValidationMessages::VALID_EMAIL_REGEX }

    validate :verify_user_exist

    def verify_user_exist
      unless User.find_by(email: email).present?
        errors.add :verify_user_exist, :invalid, message: Messages::INVALID_EMAIL
      end
    end
  end
end
