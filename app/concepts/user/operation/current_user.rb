module User::Operation
  class CurrentUser < Trailblazer::Operation
    step :get_current_user!

    def get_current_user!(options, **)
      if options['admin_flg']
        options['current_user'] = User.where("users.id = ? and users.role = '1'", options['user_id'])
      else
        options['current_user'] ||= User.find_by(id: options['user_id'])
      end
      true
    end
  end
end
