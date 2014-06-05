class Health
  THRESHOLD = 2
  def self.update(endpoint, last_5, last_hour)
    current_rates  = compute_rates(last_5)
    previous_rates = compute_rates(last_hour)

    health, msg = if no_data?(last_5) && no_data?(last_hour)
      ["gray", "not enough data"]
    elsif no_data?(last_5) # nothing changed
      [endpoint.health, endpoint.health_msg]
    elsif current_rates[:errors] > 5
      ["red", "#{current_rates[:errors].to_i}% errors"]
    elsif current_rates[:errors] > (previous_rates[:errors] + THRESHOLD)
      increase = current_rates[:errors] - previous_rates[:errors]
      ["red", "error rate increased #{increase.to_i}%"]
    else
      ["green"]
    end

    endpoint.update(stats: last_hour, health: health, health_msg: msg)
  end

  def self.no_data?(stats)
    stats.empty? || stats.values.all? { |v| v == 0 }
  end

  def self.compute_rates(stats)
    rates = {
      errors: 0,
      user_errors: 0,
    }
    total = stats.values.inject(0) { |t, reqs| t += reqs }
    return rates if total == 0

    stats.each do |status, reqs|
      case status
      when 500..503
        rates[:errors] += reqs
      when 400..429
        rates[:user_errors] += reqs
      end
    end

    rates.inject({}) do |adjusted, (rate, qty)|
      adjusted[rate] = (qty * 100) / total.to_f
      adjusted
    end
  end
end
