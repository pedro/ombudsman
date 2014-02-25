migration "create apps" do
  database.create_table :apps do
    primary_key :id
    text        :heroku_id
    text        :syslog_token
  end
end

migration "add drain_secret" do
  database.add_column :apps, :drain_secret, :text
end

migration "create requests" do
  database.create_table :requests do
    primary_key :id
    foreign_key :app_id
    text        :secret
    text        :verb
    text        :path
    integer     :status
  end
end

class App < Sequel::Model
  def before_create
    self.drain_secret ||= SecureRandom.hex(8)
  end

  def log_drain_url
    ENV["LOG_DRAIN_URL"] + "/#{id}/#{drain_secret}"
  end

  def serialized
    {
      id: id,
      syslog_drain_url: log_drain_url
    }
  end
end

class Request < Sequel::Model
end

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