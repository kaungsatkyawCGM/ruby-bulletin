module Auth::Operation
  class Login < Trailblazer::Operation
    class Present < Trailblazer::Operation
      step Model(User, :new)
      step Contract::Build(constant: Auth::Contract::Login)
    end
    step Nested(Present)
    step Contract::Validate(key: :user)
    step :login!

    def login!(options, params:, **)
      user = User.find_by(email: params[:user][:email].downcase)
      if user&.authenticate(params[:user][:password])
        options['user'] = user
        true
      else
        options['invalid_login'] = Messages::INVALID_LOGIN
        false
      end
    end
  end
end
