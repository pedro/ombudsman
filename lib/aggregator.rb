class Aggregator
  attr_accessor :app, :requests

  def initialize(app, requests)
    @app = app
    @requests = requests
  end

  def work!
    requests.each do |req|
      Endpoint.create(
        app: app,
        signature: req.path)
    end
  end
end