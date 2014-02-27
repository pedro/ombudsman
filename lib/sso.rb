class SSO < Sinatra::Base
  use Rack::Session::Cookie, secret: ENV['SSO_SALT']

  set :root, "./"

  helpers do
    def label_for_health(endpoint_health)
      case endpoint_health
      when "green"
        "label-success"
      when "yellow"
        "label-warning"
      when "red"
        "label-danger"
      when "gray"
        "label-default"
      end
    end
  end

  get "/heroku/resources/:id" do
    @app = App.first(id: params[:id])
    erb :dashboard
  end
end
