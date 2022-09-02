class UserService

  class << self
    # require "#{Rails.root}/app/repositories/user_repository"
      # function: getAllUserList
      # get user list
      # params: 
      def getAllUserList
        @users = UserRepository.getAllUserList
      end

      def getUserById(id)
        @user = UserRepository.getUserById(id)
      end

      def findByEmail(email)
        @user = UserRepository.findByEmail(email)
      end
  end
end