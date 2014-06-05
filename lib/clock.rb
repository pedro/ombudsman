require "clockwork"
require "./lib/ombudsman"

$stdout.sync = true

module Clockwork
  every(5.minutes, "store-stats", thread: true) do
    Endpoint.dataset.use_cursor.each do |e|
      puts "updating #{e.id}"
      last_5    = Stats.summary(e, 5)
      last_hour = Stats.summary(e, 60)
      Health.update(e, last_5, last_hour)
    end
  end
end
