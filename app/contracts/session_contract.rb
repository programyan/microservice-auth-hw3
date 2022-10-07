module Contracts
  class SessionContract < Dry::Validation::Contract
    params do
      required(:email).filled(:str?)
      required(:password).filled(:str?)
    end
  end
end