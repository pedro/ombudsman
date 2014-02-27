class Health
  THRESHOLD = 5
  def self.update(endpoint, stats)
    current_error_rate  = compute_error_rate(stats)
    previous_error_rate = compute_error_rate(endpoint.stats)

    health = if stats.empty? || stats.values.all? { |v| v == 0 }
      "gray"
    elsif current_error_rate > 20
      "red"
    elsif (previous_error_rate + THRESHOLD) < current_error_rate
      "red"
    else
      "green"
    end

    puts "health #{endpoint.id}=#{health}"
    endpoint.update(stats: stats, health: health)
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
