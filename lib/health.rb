class Health
  THRESHOLD = 2
  def self.update(endpoint, last_5, last_hour)
    current_error_rate  = compute_error_rate(last_5)
    previous_error_rate = compute_error_rate(last_hour)

    health, msg = if no_data?(last_5) && no_data?(last_hour)
      ["gray", "not enough data"]
    elsif no_data?(last_5) # nothing changed
      [endpoint.health, endpoint.health_msg]
    elsif current_error_rate > 5
      ["red", "#{current_error_rate.to_i}% errors"]
    elsif (previous_error_rate + THRESHOLD) < current_error_rate
      increase = current_error_rate - previous_error_rate
      ["red", "error rate increased #{increase.to_i}%"]
    else
      ["green"]
    end

    endpoint.update(stats: last_hour, health: health, health_msg: msg)
  end

  def self.no_data?(stats)
    stats.empty? || stats.values.all? { |v| v == 0 }
  end

  def self.compute_error_rate(stats)
    total = stats.values.inject(0) { |t, reqs| t += reqs }
    return 0 if total == 0
    bad = stats.inject(0) do |t, (status, reqs)|
      next t unless status >= 500
      t += reqs
    end
    (bad * 100) / total.to_f
  end
end
