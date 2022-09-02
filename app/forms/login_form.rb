class LoginForm
  include ActiveModel::Model

  validates :email, presence: true
  class << self
      def initialize(params)
          {
              :email => params.email,
              :password => params.password
          }
      end        
  end
end