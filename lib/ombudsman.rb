require "sinatra"
require "sinatra/sequel"
require "./lib/database"

module Ombudsman
  class API < Sinatra::Base
    set :database, ENV["DATABASE_URL"]

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
      app = App.create(
        heroku_id: options[:heroku_id])
      content_type :json
      MultiJson.encode(app.serialized)
    end
  end
end