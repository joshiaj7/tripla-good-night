require 'rails_helper'

describe ScheduleService::ClockIn, type: :service do
  let(:run_service) { ScheduleService.clock_in(params) }
  let(:params)      { { user_id: user_id } }
  let(:user_id)     { 1 }

  context "when user_id is not present" do
    let(:user_id) { nil }

    it "raises an error" do
      expect { run_service }.to raise_error(::BaseError::UserUnauthorizedError)
    end
  end

  context "when user_id is present" do
    context "when user is not found" do
      let(:user_id) { 1 }

      it "raises an error" do
        expect { run_service }.to raise_error(::BaseError::UserNotFoundError)
      end
    end

    context "when user is found" do
      let(:user) { create(:user, id: user_id) }

      before do
        allow(User).to receive(:find_by).with(id: user_id).and_return(user)
        allow(KafkaClient).to receive(:deliver_message)
      end

      it "sends a message with the correct clock_in_at time" do
        frozen_time = Time.new(2024, 4, 16, 9, 0, 0).utc

        travel_to(frozen_time) do
          expect(KafkaClient).to receive(:deliver_message).with(
            {
              user_id: user_id,
              clock_in_at: frozen_time
            }.to_json,
            topic: "schedule-clock-in"
          )

          run_service
        end
      end
    end
  end
end
