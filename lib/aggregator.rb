class Aggregator
  attr_accessor :app, :request

  def initialize(app, request)
    @app = app
    @request = request
    @signmap = app.endpoints.inject({}) do |h, endpoint|
      h[endpoint.signature] = endpoint
      h
    end
  end

  def work!
    parts = request.path.split("/")
    signature = parts.map { |p| p.sub(/^\d+$/, "\\d+") }.join("/")
    @signmap[signature] ||= Endpoint.create(app: app, signature: signature)
  end
end