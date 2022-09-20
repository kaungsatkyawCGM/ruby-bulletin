require "reform/form/validation/unique_validator"

module User::Contract
  class Update < Reform::Form
    property :email
    property :name
    property :role
    property :phone
    property :created_by
    property :updated_by
    property :created_at

    validates :name, presence: { message: ValidationMessages::REQUIRED },
                     length: { maximum: 255, too_long: ValidationMessages::MAXIMUN }
    validates :email, presence: { message: ValidationMessages::REQUIRED }, length: { maximum: 255, too_long: ValidationMessages::MAXIMUN },
                      format: { with: Constants::VALID_EMAIL_REGEX },
                      unique: true
    validates :phone, numericality: { message: ValidationMessages::VALID_INTEGER },
                      length: { minimum: 10, maximum: 15, too_short: ValidationMessages::MINIMUN, too_long: ValidationMessages::MAXIMUN }, allow_blank: true
    validates :role, inclusion: { in: %w[1 0] }
  end
end
