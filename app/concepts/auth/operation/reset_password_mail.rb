module Auth::Operation
  class ResetPasswordMail < Trailblazer::Operation
    class Present < Trailblazer::Operation
      step Model(PasswordReset, :new)
      step Contract::Build(constant: Auth::Contract::ResetPasswordMail)
    end
    step Nested(Present)
    step Contract::Validate(key: :password_reset)
    step :mail_sent!

    def mail_sent!(options, params:, **)
      @password_reset = PasswordReset.new
      @password_reset.token = SecureRandom.hex(10)
      @password_reset.sent_at = Time.now.utc
      @password_reset.email = params[:password_reset][:email]
      @password_reset.save!
      ResetPasswordMailer.new_reset_password_email(@password_reset).deliver_later
      return true
    end
  end
end
