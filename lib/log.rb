class Log
  def self.parse(app_id, secret, raw)
    # STABLE AS FUCK:
    return false unless raw.include?("host heroku router - at=info method=")

    unless data = raw.match(/method=(\w+) path=([^ ]+) .* status=(\d+)/)
      return false
    end

    Request.create(
      app_id: app_id,
      secret: secret,
      verb: data[1].downcase,
      path: data[2],
      status: data[3].to_i)
  end
end
