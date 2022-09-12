class UserRepository
  class << self
    def getAllUserList(user_id)
      @users = User.where(deleted_at: nil).where.not(id: user_id)
    end

    def getUserById(id)
      @user = User.find_by(id: id)
    end

    def findByEmail(email)
      @user = User.find_by(email: email)
    end

    def deleteUser(user)
      user.destroy
    end

    def getAdminUser(user_id)
      @user = User.where("users.id = ? and users.role = '1'", user_id)
    end

    def save(user)
      @is_save = user.save
    end

    def create(params)
      @user = User.create(params)
    end

    def update(user, user_params)
      @is_update = user.update(user_params)
    end
  end
end
