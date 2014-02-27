class Stats
  WINDOW = 5 # in minutes

  def self.record(endpoint, status)
    t = Time.now
    bucket = t.min % WINDOW
    key = "#{endpoint.id}:#{bucket}"

    # TOTALLY SAFE AGAINST RACE CONDITIONS!!!11
    exists = Cache.exists(key)
    Cache.hincrby(key, status.to_s, 1)
    unless exists
      Cache.expire(key, WINDOW * 60)
    end
  end

  def self.summary(endpoint)
    t = Time.now
    stats = Hash.new(0)
    (0..WINDOW).each do |bucket|
      Cache.hgetall("#{endpoint.id}:#{bucket}").each do |k, v|
        stats[k.to_i] += v.to_i
      end
    end
    stats
  end
end