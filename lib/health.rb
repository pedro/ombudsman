class Health
  def self.update(endpoint, stats)
    endpoint.update(stats: stats)
  end
end
