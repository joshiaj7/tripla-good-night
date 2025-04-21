require "rails_helper"

RSpec.describe ::ScheduleController, type: :controller do
  describe "#leaderboards" do
    let(:run_service) { post :leaderboards, params: params }
    let(:params) { { limit: limit, offset: offset } }
    let(:limit) { 10 }
    let(:offset) { 0 }
    let(:user_id)  { 1 }
    let(:leaderboard_params) { { user_id: user_id, limit: limit, offset: offset } }
    let(:leaderboard_result) { [ { schedule_id: 1, duration: 120, user_name: "John Doe" } ] }
    let(:leaderboard_meta) { { total_count: 1, limit: limit, offset: offset } }

    context "when the user is authenticated" do
      before do
        allow(controller).to receive(:current_user_id).and_return(user_id)
        allow(ScheduleService).to receive(:get_leaderboard).with(leaderboard_params).and_return(leaderboard_result, leaderboard_meta)
      end

      it "calls the get_leaderboard method of ScheduleService" do
        expect(ScheduleService).to receive(:get_leaderboard).with(leaderboard_params)
        run_service
      end

      it "returns a success message" do
        run_service
        expect(response.status).to eq(200)
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
        allow(ScheduleService).to receive(:get_leaderboard).and_raise(StandardError.new("An error occurred"))
      end

      it "returns an error message" do
        run_service
        expect(response.status).to eq(500)
        expect(JSON.parse(response.body)["error"]).to eq("An error occurred")
      end
    end
  end
end
