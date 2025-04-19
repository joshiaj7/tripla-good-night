require "rails_helper"

RSpec.describe ::UserController, type: :controller do

  describe "#signup" do
    let(:params) { { name: "John Doe" } }
    let(:invalid_param_error) { ::BaseError::InvalidParameterError.new("name") }

    context "when user is created successfully" do
      before do
        allow(UserService).to receive(:sign_up).with(params)
        post :signup, params: params
      end

      it "calls the UserService sign_up method" do
        expect(UserService).to have_received(:sign_up).with(params)
      end

      it "returns a success message" do
        expect(response.body).to eq({ message: "User created successfully" }.to_json)
      end

      it "returns a 200 status code" do
        expect(response.status).to eq(200)
      end
    end

    context "when invalid parameter error" do
      before do
        allow(UserService).to receive(:sign_up).with(params).and_raise(invalid_param_error)
        post :signup, params: params
      end

      it "calls the UserService sign_up method" do
        expect(UserService).to have_received(:sign_up).with(params)
      end

      it "returns an error message" do
        expect(response.body).to eq({ error: "invalid parameter: name" }.to_json)
      end

      it "returns a 500 status code" do
        expect(response.status).to eq(422)
      end
    end

    context "when an unexpected error occurs" do  
      let(:unexpected_error) { StandardError.new("Unexpected error") }

      before do
        allow(UserService).to receive(:sign_up).with(params).and_raise(unexpected_error)
        post :signup, params: params
      end

      it "calls the UserService sign_up method" do
        expect(UserService).to have_received(:sign_up).with(params)
      end

      it "returns an unexpected error message" do
        expect(response.body).to eq({ error: "Unexpected error" }.to_json)
      end

      it "returns a 500 status code" do
        expect(response.status).to eq(500)
      end
    end
  end
end
