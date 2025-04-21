require "rails_helper"

RSpec.describe ::ScheduleController, type: :controller do
  describe "#clock_in" do
    let(:run_service) { post :clock_in, params: params }
    let(:params) { { user_id: user_id } }
    let(:user_id)  { 1 }
    let(:clock_in_params) { { user_id: user_id } }

    context "when the user is authenticated" do
      before do
        allow(controller).to receive(:current_user_id).and_return(user_id)
        allow(ScheduleService).to receive(:clock_in).with(clock_in_params)
      end

      it "calls the clock_in method of ScheduleService" do
        expect(ScheduleService).to receive(:clock_in).with(clock_in_params)
        run_service
      end

      it "returns a success message" do
        run_service
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)["message"]).to eq("clock in successfully")
      end
    end

    context "when the user is not authenticated" do
      before do
        allow(controller).to receive(:current_user_id).and_raise(::BaseError::UserUnauthorizedError.new)
      end

      it "returns error message" do
        run_service
        expect(response.status).to eq(401)
        expect(JSON.parse(response.body)["error"]).to eq("user is unauthorized")
      end
    end

    context "when an error occurs" do
      before do
        allow(controller).to receive(:current_user_id).and_return(user_id)
        allow(ScheduleService).to receive(:clock_in).and_raise(StandardError.new("An error occurred"))
      end

      it "returns an error message" do
        run_service
        expect(response.status).to eq(500)
        expect(JSON.parse(response.body)["error"]).to eq("An error occurred")
      end
    end
  end
end
