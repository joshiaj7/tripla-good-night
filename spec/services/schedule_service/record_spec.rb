require 'rails_helper'

describe ScheduleService::Record, type: :service do
  let(:run_service) { ScheduleService.record(params) }
  let(:params)      { { user_id: user_id, clocked_in_at: clocked_in_at } }
  let(:user_id)     { 1 }
  let(:clocked_in_at) { Time.now.utc }

  context "when user_id is not present" do
    let(:user_id) { nil }

    it "raises an error" do
      expect { run_service }.to raise_error(::BaseError::InvalidParameterError)
    end
  end

  context "when clocked_in_at is not present" do
    let(:clocked_in_at) { "" }

    it "raises an error" do
      expect { run_service }.to raise_error(::BaseError::InvalidParameterError)
    end
  end

  context "when user is not found" do
    let(:user_id) { 1 }

    it "raises an error" do
      expect { run_service }.to raise_error(::BaseError::UserNotFoundError)
    end
  end

  context "when latest schedule is present" do
    let(:user) { create(:user, id: user_id) }
    let(:latest_schedule) { create(:schedule, user_id: user_id, clocked_in_at: clocked_in_at - 1.hour) }

    before do
      allow(User).to receive(:find_by).with(id: user_id).and_return(user)

      schedule_relation = Schedule.where(nil) # an empty relation
      allow(schedule_relation).to receive(:order).and_return([ latest_schedule ])
      allow(Schedule).to receive(:where).and_return(schedule_relation)
    end

    context "when the user has already clocked in" do
      it "updates the latest schedule record" do
        travel_to(clocked_in_at + 1.hour) do
          run_service

          expect(latest_schedule.reload.clocked_out_at.to_i).to eq(clocked_in_at.to_i)
          expect(latest_schedule.reload.duration_in_seconds).to eq(3600)
        end
      end
    end

    context "when the previous schedule is completed" do
      before do
        latest_schedule.update(clocked_out_at: clocked_in_at - 1.hour, duration_in_seconds: 3600)
      end

      it "creates a new schedule record" do
        travel_to(clocked_in_at + 1.hour) do
          result = run_service

          expect(Schedule.count).to eq(2)
          expect(result.clocked_in_at.to_i).to eq(clocked_in_at.to_i)
        end
      end
    end
  end
end
