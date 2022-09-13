class ChangePasswordForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  validates_confirmation_of :password

  validates :password, :password_confirmation, presence: { message: Validations::REQUIRED }, on: :reset_password

  validates :old_password, :password, :password_confirmation, presence: { message: Validations::REQUIRED }, on: :change_password

  validates :password, length: { minimum: 8, maximum: 20, too_short: Validations::MINIMUN, too_long: Validations::MAXIMUN }

  validate :verify_old_password, on: :change_password

  attr_accessor :old_password, :password, :password_confirmation

  def initialize(user)
    @user = user
  end

  def submit(params)
    self.old_password = params[:old_password]
    self.password = params[:password]
    self.password_confirmation = params[:password_confirmation]
    if valid?(:change_password)
      UserService.change_password(@user, password, password_confirmation)
      return true
    end
    false
  end

  def reset_password(params)
    self.password = params[:password]
    self.password_confirmation = params[:password_confirmation]
    if valid?(:reset_password)
      UserService.change_password(@user, password, password_confirmation)
      return true
    end
    false
  end

  def verify_old_password
    errors.add :verify_old_password, :invalid, message: 'Not valid old Password' unless @user.authenticate(old_password)
  end

  def persisted?
    false
  end
end
