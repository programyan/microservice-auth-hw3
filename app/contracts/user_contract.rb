module Contracts
  class UserContract < Dry::Validation::Contract
    params do
      required(:name).filled(:str?)
      required(:email).filled(:str?)
      required(:password).filled(:str?)
    end
  end
end