module User::Contract
  class ChangePassword < Reform::Form
    property :old_password
    property :password
    property :password_confirmation

    validates :old_password, :password, :password_confirmation, presence: { message: ValidationMessages::REQUIRED }

    validates :password, confirmation: true, length: { minimum: 8, maximum: 20, too_short: ValidationMessages::MINIMUN, too_long: ValidationMessages::MAXIMUN }
  end
end
