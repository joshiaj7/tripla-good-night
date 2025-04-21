namespace :kafka do
  task consume: :environment do
    ScheduleClockInConsumer.start
  end
end
