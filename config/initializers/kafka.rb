require "kafka"

KafkaClient = Kafka.new(
  seed_brokers: ENV.fetch("KAFKA_BROKERS", "localhost:9092").split(","),
  client_id: "good-night-app"
)
