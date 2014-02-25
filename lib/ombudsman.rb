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

      def respond(hash)
        content_type :json
        MultiJson.encode(hash)
      end
    end

    before do
      unless authorized?
        response["WWW-Authenticate"] = %(Basic realm="Restricted Area")
        halt [401, "Not authorized"]
      end
    end

    post "/heroku/resources" do
      options = MultiJson.decode(request.env["rack.input"].read)
      app = App.create(
        heroku_id: options["heroku_id"],
        syslog_token: options["syslog_token"])
      respond(app.serialized)
    end

    delete "/heroku/resources/:id" do
      unless app = App.find(id: params[:id])
        halt [404, "App not found"]
      end
      app.destroy
      respond({})
    end
  end

  class Drain < Sinatra::Base
    post "/drain" do
      log = request.env["rack.input"].read
      puts log
      ""
    end
  end
end