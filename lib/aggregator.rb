class Aggregator
  attr_accessor :app, :request

  def initialize(app, request)
    @app = app
    @request = request
    @signmap = app.endpoints.inject({}) do |h, endpoint|
      h["#{endpoint.verb} #{endpoint.signature}"] = endpoint
      h
    end
  end

  def work!
    parts = request.path.split("/")
    signature = parts.map { |p| p.sub(/^\d+$/, "*") }.join("/")
    hash = "#{request.verb} #{signature}"
    @signmap[hash] ||= Endpoint.create(
      app: app, verb: request.verb, signature: signature)
  end
end