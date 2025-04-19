require 'rails_helper'

describe UserService::LogIn, type: :service do
  let(:run_service) { UserService.log_in(params) }
  let(:params)      { { id: id } }
  let(:id)          { 1 }

  context "when id is not present" do
    let(:id) { nil }

    it "raises an error" do
      expect { run_service }.to raise_error(::BaseError::InvalidParameterError)
    end
  end

  context "when id is present" do
    context "when user is not found" do
      let(:id) { 1 }

      it "raises an error" do
        expect { run_service }.to raise_error(::BaseError::UserNotFoundError)
      end
    end

    context "when user is found" do
      let(:user) { create(:user, id: id) }

      before do
        allow(User).to receive(:find).with(id).and_return(user)
      end

      it "returns a JWT token" do
        token = run_service
        expect(token).to be_a(String)
      end

      it "encodes the user_id and name in the token" do
        token = run_service
        decoded_token = JsonWebToken.decode(token)
        expect(decoded_token[:sub]).to eq(user.id)
      end
    end
  end
end
