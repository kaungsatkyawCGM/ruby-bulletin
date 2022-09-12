class PasswordResetRepository
  class << self
    def findByToken(token)
      @password_reset = PasswordReset.find_by(token:)
    end

    def save(password_reset)
      return password_reset.save!
    end
  end
end
