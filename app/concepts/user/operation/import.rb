module User::Operation
  class Import < Trailblazer::Operation
    step Model(User, :new)
    step Contract::Build(constant: User::Contract::Import)
    step Contract::Validate()
    step :import!

    def import!(options, params:, model:, **)
      User.create(params)
      true
    end
  end
end
