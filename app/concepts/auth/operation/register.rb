module Auth::Operation
  class Register < Trailblazer::Operation
    class Present < Trailblazer::Operation
      step Model(User, :new)
      step Contract::Build(constant: Auth::Contract::Register)
    end
    step Nested(Present)
    step :assign_user_role!
    step Contract::Validate(key: :user)
    step :register!

    def assign_user_role!(options, **)
      options[:params][:user][:role] = 0
    end

    def register!(options, params:, **)
      @user_params = params.require(:user).permit(:name, :email, :password, :password_confirmation, :role, :phone, :created_by, :updated_by)
      @user = User.new(@user_params)
      if @user.save
        user = User.find_by(email: params[:user][:email].downcase)
        if user&.authenticate(params[:user][:password])
          options['user'] = user
          return true
        end
      end
      false
    end
  end
end
