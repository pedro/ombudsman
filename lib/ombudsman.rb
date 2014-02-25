module Ombudsman
  class API < Sinatra::Base
    post "/heroku/resources" do
      options = MultiJson.decode(request.env["rack.input"].read)
      app = {}
      content_type :json
      MultiJson.encode(app)
    end
  end
end