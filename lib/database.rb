class App < Sequel::Model
  one_to_many :endpoints

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

class Endpoint < Sequel::Model
  many_to_one :app
end
