class PasswordResetService
  class << self
    def findByToken(token)
      @password_reset = PasswordResetRepository.findByToken(token)
    end

    def save(password_reset)
      PasswordResetRepository.save(password_reset)
    end
  end
end
