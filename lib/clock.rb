require "clockwork"
require "./lib/ombudsman"

module Clockwork
  every(5.minutes, "store-stats", thread: true) do
    Endpoint.dataset.use_cursor.each do |e|
      e.stats = Stats.summary(e)
      e.save
    end
  end
end
