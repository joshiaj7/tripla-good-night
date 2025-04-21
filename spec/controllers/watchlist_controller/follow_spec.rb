require "rails_helper"

RSpec.describe ::WatchlistController, type: :controller do
  describe "#follow" do
    let(:params) { {  followed_id: followed_id } }
    let(:watchlist_params) { { follower_id: user_id, followed_id: followed_id, active: true } }
    let(:user_id) { 1 }
    let(:followed_id) { 2 }
    let(:run_controller) {  post :follow, params: params }

    context "when follow is successful" do
      before do
        allow(WatchlistService).to receive(:create_or_update).with(watchlist_params).and_return(true)
        allow(controller).to receive(:current_user_id).and_return(user_id)
        run_controller
      end

      it "calls the WatchlistService create_or_update method" do
        expect(WatchlistService).to have_received(:create_or_update).with(watchlist_params)
      end

      it "returns a success message" do
        expect(response.body).to eq({ data: { message: "followed successfully" } }.to_json)
      end

      it "returns a 200 status code" do
        expect(response.status).to eq(200)
      end
    end

    context "when an error occurs" do
      let(:error_message) { "some error" }
      let(:error) { StandardError.new(error_message) }

      before do
        allow(WatchlistService).to receive(:create_or_update).with(watchlist_params).and_raise(error)
        allow(controller).to receive(:current_user_id).and_return(user_id)
        run_controller
      end

      it "calls the WatchlistService create_or_update method" do
        expect(WatchlistService).to have_received(:create_or_update).with(watchlist_params)
      end

      it "returns an error message" do
        expect(response.body).to eq({ error: error_message }.to_json)
      end

      it "returns a 500 status code" do
        expect(response.status).to eq(500)
      end
    end
  end
end
