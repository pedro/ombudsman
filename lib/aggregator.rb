class Aggregator
  attr_accessor :app, :requests

  def initialize(app, requests)
    @app = app
    @requests = requests
    @signmap = app.endpoints.inject({}) do |h, endpoint|
      h[endpoint.signature] = endpoint
      h
    end
  end

  def work!
    requests.each do |req|
      parts = req.path.split("/")
      signature = parts.map { |p| p =~ /^\d+$/ ? "*" : p }.join("/")
      @signmap[signature] ||= Endpoint.create(app: app, signature: signature)
    end
  end
end