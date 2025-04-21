require 'rails_helper'

describe ScheduleService::GetLeaderboard, type: :service do
  let(:run_service) { ScheduleService.get_leaderboard(params) }
  let(:params)      { { user_id: user_id, limit: limit, offset: offset } }
  let(:user_id)     { 1 }
  let(:limit)       { 3 }
  let(:offset)      { 0 }

  context "when user_id is not present" do
    let(:user_id) { nil }

    it "raises an error" do
      expect { run_service }.to raise_error(::BaseError::UserUnauthorizedError)
    end
  end

  context "when user_id is present" do
    context "when user is not found" do
      before do
        allow(User).to receive(:find_by).with(id: user_id).and_return(nil)
      end

      it "raises a UserNotFoundError" do
        expect { run_service }.to raise_error(::BaseError::UserNotFoundError)
      end
    end

    context "when user is found" do
      let(:user) { create(:user, id: user_id) }

      before do
        allow(User).to receive(:find_by).with(id: user_id).and_return(user)
      end

      context "when there are no schedules" do
        it "returns an empty result" do
          result, meta = run_service

          expect(result).to be_empty
          expect(meta[:total_count]).to eq(0)
        end
      end

      context "when there are schedules" do
        let(:followed_users) do
          (2..4).map { |i| create(:user, id: i) }
        end
        let(:watchlists) { create(:watchlist, follower_id: user1.id, followed_id: user2.id) }

        before do
          followed_users.each do |followed|
            create(:watchlist, follower_id: user.id, followed_id: followed.id)
          end

          # Create some schedules for followed users (some from last week, some outside)
          followed_users.each_with_index do |followed, i|
            # Valid schedule from last week
            clocked_in = 1.week.ago.beginning_of_week + i.hours
            clocked_out = clocked_in + 2.hours
            create(:schedule, user_id: followed.id, clocked_in_at: clocked_in, clocked_out_at: clocked_out, duration_in_seconds: 7200 + followed.id, created_at: clocked_in)
          end
        end

        it "returns the schedules sorted by duration" do
          result, meta = run_service

          expect(result.size).to eq(3)
          expect(result.first[:duration]).to eq(7204)
          expect(result.last[:duration]).to eq(7202)
          expect(meta[:total_count]).to eq(3)
        end
      end
    end
  end
end
