module User::Operation
  class ChangePassword < Trailblazer::Operation
    class Present < Trailblazer::Operation
      step Model(User, :new)
      step Contract::Build(constant: User::Contract::ChangePassword)
    end
    step Nested(Present)
    step :verify_old_password
    step Contract::Validate(key: :user)
    step :update!

    def update!(options, params:, **)
      @user_params = params.require(:user).permit(:password, :password_confirmation)
      options['current_user_obj'].update(@user_params)
    end

    def verify_old_password(options, params:, **)
      unless params[:user][:old_password].blank?
        options['verify_old_password'] = 'Not valid old Password' unless options['current_user_obj'].authenticate(params[:user][:old_password])
      end
      true
    end
  end
end