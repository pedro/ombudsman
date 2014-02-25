module Ombudsman
  class API < Sinatra::Base
    helpers do
      def authorized?
        @auth ||=  Rack::Auth::Basic::Request.new(request.env)
        @auth.provided? && @auth.basic? && @auth.credentials &&
        @auth.credentials == [ENV["HEROKU_USERNAME"], ENV["HEROKU_PASSWORD"]]
      end
    end

    before do
      unless authorized?
        response["WWW-Authenticate"] = %(Basic realm="Restricted Area")
        throw(:halt, [401, "Not authorized\n"])
      end
    end

    post "/heroku/resources" do
      options = MultiJson.decode(request.env["rack.input"].read)
      app = {}
      content_type :json
      MultiJson.encode(app)
    end
  end
end