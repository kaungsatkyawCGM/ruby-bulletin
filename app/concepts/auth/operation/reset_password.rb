module Auth::Operation
  class ResetPassword < Trailblazer::Operation
    class Present < Trailblazer::Operation
      step Model(User, :new)
      step Contract::Build(constant: Auth::Contract::ResetPassword)
    end
    step Nested(Present)
    step Contract::Validate(key: :user)
    step :reset_password!

    def reset_password!(options, params:, **)
      token = params[:token].to_s
      @password_reset = PasswordReset.find_by(token: token)

      unless @password_reset&.password_token_valid?
        options['no_valid_token'] = true
        return false
      end
      @user_params = params.require(:user).permit(:password, :password_confirmation)

      @user = User.find_by(email: @password_reset[:email])
      @user.update(@user_params)
      return true
    end
  end
end
