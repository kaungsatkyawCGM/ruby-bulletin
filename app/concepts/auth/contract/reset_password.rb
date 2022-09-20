module Auth::Contract
  class ResetPassword < Reform::Form
    property :password
    property :password_confirmation

    validates :password, :password_confirmation, presence: { message: ValidationMessages::REQUIRED }

    validates :password, confirmation: true, length: { minimum: 8, maximum: 20, too_short: ValidationMessages::MINIMUN, too_long: ValidationMessages::MAXIMUN }
  end
end
