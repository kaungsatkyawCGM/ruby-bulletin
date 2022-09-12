class LoginForm
  include ActiveModel::Model

  validates :email, :password, presence: { message: Validations::REQUIRED }

  attr_accessor :email, :password

  def initialize(params)
    self.email = params[:email]
  end
end
