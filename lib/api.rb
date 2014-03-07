class API < Sinatra::Base
  set :database, ENV["DATABASE_URL"]

  helpers do
    def authorize_api!
      unless authorized?
        response["WWW-Authenticate"] = %(Basic realm="Restricted Area")
        halt [401, "Not authorized"]
      end
    end

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

  post "/heroku/resources" do
    authorize_api!
    options = MultiJson.decode(request.env["rack.input"].read)
    app = App.create(
      heroku_id: options["heroku_id"],
      syslog_token: options["syslog_token"])
    Cache.set("auth-#{app.id}", app.drain_secret)
    respond(app.serialized)
  end

  delete "/heroku/resources/:id" do
    authorize_api!
    unless app = App.find(id: params[:id])
      halt [404, "App not found"]
    end
    app.destroy
    Cache.del("auth-#{app.id}")
    respond({})
  end
end
