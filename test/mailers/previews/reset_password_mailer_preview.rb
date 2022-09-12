# Preview all emails at http://localhost:3000/rails/mailers/reset_password_mailer
class ResetPasswordMailerPreview < ActionMailer::Preview
  def new_reset_password_email
    ResetPasswordMailer.new_reset_password_email(email: "exampl@gmail.com")
  end
end
