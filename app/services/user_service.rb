class UserService
  class << self
    def getAllUserList(user_id)
      @users = UserRepository.getAllUserList(user_id)
    end

    def getUserById(id)
      @user = UserRepository.getUserById(id)
    end

    def findByEmail(email)
      @user = UserRepository.findByEmail(email)
    end

    def deleteUser(user)
      UserRepository.deleteUser(user)
    end

    def getAdminUser(user_id)
      @user = UserRepository.getAdminUser(user_id)
    end

    def save(user, auth_user_id)
      unless auth_user_id.nil?
        user.created_by = auth_user_id
        user.updated_by = auth_user_id
      end
      @is_save = UserRepository.save(user)
    end

    def create(params)
      @user = UserRepository.create(params)
    end

    def update(user, auth_user_id, user_params)
      user.updated_by = auth_user_id
      @is_update = UserRepository.update(user, user_params)
    end

    def change_password(user, password, password_confirmation)
      user.password = password
      user.password_confirmation = password_confirmation
      UserRepository.save(user)
    end
  end
end
