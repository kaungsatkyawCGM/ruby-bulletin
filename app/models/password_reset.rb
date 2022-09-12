class PasswordReset < ApplicationRecord
  def password_token_valid?
    (sent_at + 4.hours) > Time.now.utc
  end
end
