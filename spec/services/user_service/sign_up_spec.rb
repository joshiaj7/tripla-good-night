require 'rails_helper'

describe UserService::SignUp, type: :service do
  let(:run_service) { UserService.sign_up(params) }
  let(:params)      { { name: name } }
  let(:name)        { "John Doe" }

  context "when name is not present" do
    let(:name) { "" }

    it "raises an error" do
      expect { run_service }.to raise_error(::BaseError::InvalidParameterError)
    end
  end

  context "when name is present" do
    it "creates a new user" do
      expect { run_service }.to change { User.count }.by(1)
    end

    it "sets the name of the user" do
      user = run_service
      expect(user.name).to eq(name)
    end
  end
end
