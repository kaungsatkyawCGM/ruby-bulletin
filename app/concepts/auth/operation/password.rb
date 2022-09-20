module Auth::Operation
  class Password < Trailblazer::Operation
    step :get_password_reset!

    def get_password_reset!(options, params:, **)
      token = params[:token].to_s
      options['password_reset'] = PasswordReset.find_by(token: token)
    end
  end
end
