require "clockwork"
require "./lib/ombudsman"

module Clockwork
  every(5.minutes, "store-stats", thread: true) do
    Endpoint.dataset.use_cursor.each do |e|
      stats = Stats.summary(e)
      puts stats.inspect
    end
  end
end
