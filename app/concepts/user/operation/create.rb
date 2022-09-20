module User::Operation
  class Create < Trailblazer::Operation
    class Present < Trailblazer::Operation
      step Model(User, :new)
      step Contract::Build(constant: User::Contract::Create)
    end
    step Nested(Present)
    step :assign_created_by!
    step Contract::Validate(key: :user)
    step :create!

    def assign_created_by!(options, params:, **)
      params[:user][:created_by] = options['current_user_id']
    end

    def create!(option, params:, **)
      @user_params = params.require(:user).permit(:name, :email, :password, :password_confirmation, :role, :phone)
      @user = User.new(@user_params)
      if @user.save
        true
      else
        false
      end
    end
  end
end
