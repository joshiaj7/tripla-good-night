require "rails_helper"

RSpec.describe ::UserController, type: :controller do
  describe "#login" do
    let(:params) { { id: id } }
    let(:id)  { 1 }
    let(:token)  { "some-token" }
    let(:invalid_param_error) { ::BaseError::InvalidParameterError.new("id") }

    context "when user successfully logged in" do
      before do
        allow(UserService).to receive(:log_in).with(params).and_return(token)
        post :login, params: params
      end

      it "calls the UserService sign_up method" do
        expect(UserService).to have_received(:log_in).with(params)
      end

      it "returns a success response" do
        expect(response).to have_http_status(:ok)
      end

      it "returns the token in the response body" do
        expect(response.body).to include(token)
      end
    end

    context "when user not found" do
      before do
        allow(UserService).to receive(:log_in).with(params).and_raise(::BaseError::UserNotFoundError.new)
        post :login, params: params
      end

      it "calls the UserService sign_up method" do
        expect(UserService).to have_received(:log_in).with(params)
      end

      it "returns a not found response" do
        expect(response).to have_http_status(:not_found)
      end

      it "returns an error message in the response body" do
        expect(response.body).to include("user not found")
      end
    end

    context "when invalid parameter is provided" do
      before do
        allow(UserService).to receive(:log_in).with(params).and_raise(invalid_param_error)
        post :login, params: params
      end

      it "calls the UserService sign_up method" do
        expect(UserService).to have_received(:log_in).with(params)
      end

      it "returns a bad request response" do
        expect(response).to have_http_status(:bad_request)
      end

      it "returns an error message in the response body" do
        expect(response.body).to include("invalid parameter: id")
      end
    end
  end
end
