class UserRepository
  class << self

      # function: getAllUserList
      # get user list
      # params: 
      # return: @users
      def getAllUserList
          @users = User.where(deleted_at: nil)
      end

      def getUserById(id)
        @user = User.find(id)
      end
  end
end