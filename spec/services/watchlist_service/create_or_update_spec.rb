require 'rails_helper'

describe WatchlistService::CreateOrUpdate, type: :service do
  let(:run_service) { WatchlistService.create_or_update(params) }
  let(:params)      { { follower_id: follower_id, followed_id: followed_id, active: active } }
  let(:follower_id) { 1 }
  let(:followed_id) { 2 }
  let(:active)      { true }

  context "when follower_id is not present" do
    let(:follower_id) { nil }

    it "raises an error" do
      expect { run_service }.to raise_error(::BaseError::UserUnauthorizedError)
    end
  end

  context "when followed_id is not present" do
    let(:followed_id) { nil }

    it "raises an error" do
      expect { run_service }.to raise_error(::BaseError::InvalidParameterError)
    end
  end

  context "when follower_id is equal to followed_id" do
    let(:follower_id) { 1 }
    let(:followed_id) { 1 }

    it "raises an error" do
      expect { run_service }.to raise_error(::BaseError::FollowingYourselfError)
    end
  end

  context "when watchlist is not found" do
    it "creates a new watchlist" do
      expect { run_service }.to change(Watchlist, :count).by(1)
      expect(run_service.follower_id).to eq(follower_id)
      expect(run_service.followed_id).to eq(followed_id)
      expect(run_service.active).to eq(active)
    end
  end

  context "when watchlist is found" do
    let(:watchlist) { create(:watchlist, follower_id: follower_id, followed_id: followed_id, active: !active) }

    it "updates the watchlist" do
      expect { run_service }.to change { watchlist.reload.active }.from(!active).to(active)
    end
  end

  context "when watchlist is found and active is not changed" do
    let(:watchlist) { create(:watchlist, follower_id: follower_id, followed_id: followed_id, active: active) }

    it "does not change the watchlist" do
      expect { run_service }.not_to change { watchlist.reload.active }
    end
  end

  fcontext "when active is false" do
    let(:active) { false }

    context "when watchlist is found" do
      let(:watchlist) { create(:watchlist, follower_id: follower_id, followed_id: followed_id, active: true) }

      it "updates the watchlist to inactive" do
        expect { run_service }.to change { watchlist.reload.active }.from(true).to(false)
      end
    end

    context "when watchlist is not found" do
      it "creates a new inactive watchlist" do
        expect { run_service }.to change(Watchlist, :count).by(1)
        expect(run_service.follower_id).to eq(follower_id)
        expect(run_service.followed_id).to eq(followed_id)
        expect(run_service.active).to eq(active)
      end
    end
  end
end
