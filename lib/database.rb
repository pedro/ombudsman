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

class Request
  attr_accessor :app_id, :secret, :verb, :path, :status

  def initialize(args)
    @app_id = args[:app_id]
    @secret = args[:secret]
    @verb   = args[:verb]
    @path   = args[:path]
    @status = args[:status]
  end

  def serialized
    {
      app_id: app_id,
      secret: secret,
      verb:   verb,
      path:   path,
      status: status,
    }
  end
end

class Endpoint < Sequel::Model
  many_to_one :app
end
