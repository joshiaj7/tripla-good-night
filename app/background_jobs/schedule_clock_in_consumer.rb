class ScheduleClockInConsumer
  def self.start
    consumer = KafkaClient.consumer(group_id: "good-night-app-consumer-group")
    consumer.subscribe("schedule-clock-in")

    consumer.each_message do |message|
      payload = JSON.parse(message.value)
      ScheduleService.record(
        user_id: payload["user_id"].to_i,
        clocked_in_at: payload["clocked_in_at"].to_datetime.utc
      )
    rescue ::BaseError::GeneralError => e
      puts "Expected error: #{e.message}"
    rescue => e
      raise e
    end
  end
end
