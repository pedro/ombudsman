require "clockwork"
require "./lib/ombudsman"

module Clockwork
  every(5.minutes, "store-stats", thread: true) do
    Endpoint.dataset.use_cursor.each do |e|
      stats = Stats.summary(e)
      puts "updating #{e.id}: #{stats.inspect}"
      e.update(stats: stats)
    end
  end
end
