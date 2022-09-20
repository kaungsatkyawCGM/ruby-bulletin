module User::Operation
  class Update < Trailblazer::Operation
    class Present < Trailblazer::Operation
      step Model(User, :find_by, not_found_terminus: true)
      step :get_profile_data!
      step Contract::Build(constant: User::Contract::Update)

      def get_profile_data!(options, model:, **)
        options['user'] = model
      end
    end
    step Nested(Present)
    step :assign_updated_user!
    step Contract::Validate(key: :user)
    step :update!

    def assign_updated_user!(options, params:, **)
      params[:user][:updated_by] = options['current_user_id']
    end

    def update!(options, model:, **)
      model.update(options['user_params'])
    end
  end
end