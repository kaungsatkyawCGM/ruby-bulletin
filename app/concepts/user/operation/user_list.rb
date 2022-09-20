module User::Operation
  class UserList < Trailblazer::Operation
    step :get_user_list

    def get_user_list(options, **)
      if options['profile_id'].present?
        options['user'] = User.find_by(id: options['profile_id'])
      else
        unless options['params'].nil?
          order_column_index = options['params'][:order]['0'][:column]
          order_column = options['params'][:columns][order_column_index][:data]
          order = options['params'][:order]['0'][:dir] ? options['params'][:order]['0'][:dir] : 'asc'

          order_column << ' ' + order.upcase unless order == 'asc'
        else
          order_column = nil
          order = nil
        end

        if options['params'].nil?
          @users = User.where(deleted_at: nil).where.not(id: options['user_id'])
        else
          @users = User.where(deleted_at: nil).where.not(id: options['user_id']).where('name LIKE ? OR email LIKE ?', "%#{options['params'][:search][:value]}%", "%#{options['params'][:search][:value]}%").order(order_column)
        end
        options['users'] = @users
      end
    end
  end
end
