class Stats
  WINDOW = 60 # in minutes

  def self.record(endpoint, status)
    t = Time.now
    bucket = t.min
    key = "#{endpoint.id}:#{bucket}"

    # TOTALLY SAFE AGAINST RACE CONDITIONS!!!11
    exists = Cache.exists(key)
    Cache.hincrby(key, status.to_s, 1)
    unless exists
      Cache.expire(key, WINDOW * 60)
    end
  end

  def self.summary(endpoint, duration)
    t = Time.now
    stats = Hash.new(0)
    (duration + 1).times do |i|
      bucket = t.min - i
      bucket += 60 if bucket < 0

      Cache.hgetall("#{endpoint.id}:#{bucket}").each do |k, v|
        stats[k.to_i] += v.to_i
      end
    end
    stats
  end
end