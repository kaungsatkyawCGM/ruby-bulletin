class ResetPasswordMailer < ApplicationMailer
  default from: 'cgm.kaungsatkyaw@gmail.com'

  def new_reset_password_email(reset_mail_form)
    @reset_mail_form = reset_mail_form

    mail to: @reset_mail_form[:email],
         subject: 'Bulletin Reset Password'
  end
end
