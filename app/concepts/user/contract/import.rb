require 'reform/form/validation/unique_validator'

module User::Contract
  class Import < Reform::Form
    property :email
    property :name
    property :role
    property :phone
    property :password
    property :password_confirmation
    property :created_by
    property :updated_by

    validates :name, presence: { message: ValidationMessages::REQUIRED },
                     length: { maximum: 255, too_long: ValidationMessages::MAXIMUN }
    validates :email, presence: { message: ValidationMessages::REQUIRED }, length: { maximum: 255, too_long: ValidationMessages::MAXIMUN },
                      format: { with: Constants::VALID_EMAIL_REGEX },
                      unique: true
    validates :password, confirmation: true, presence: { message: ValidationMessages::REQUIRED },
                         length: { minimum: 8, maximum: 20, too_short: ValidationMessages::MINIMUN, too_long: ValidationMessages::MAXIMUN }
    validates :phone, numericality: { message: ValidationMessages::VALID_INTEGER },
                      length: { minimum: 10, maximum: 15, too_short: ValidationMessages::MINIMUN, too_long: ValidationMessages::MAXIMUN }, allow_blank: true
    validates :role, inclusion: { in: %w[1 0] }
  end
end
