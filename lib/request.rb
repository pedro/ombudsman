class Request
  attr_accessor :app_id, :secret, :verb, :path, :status

  def initialize(args)
    @app_id = args[:app_id]
    @secret = args[:secret]
    @verb   = args[:verb]
    @path   = args[:path]
    @status = args[:status]
  end

  def app
    App.find(id: app_id)
  end

  def to_s
    "#{app_id} #{verb} #{path} #{status}"
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
