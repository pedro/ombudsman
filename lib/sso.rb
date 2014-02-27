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

    def formatted_health_msg(endpoint)
      return '<span class="glyphicon glyphicon-ok"></span>' if endpoint.health == "green"
      endpoint.health_msg
    end
  end

  get "/heroku/resources/:id" do
    unless @app = App.find(id: params[:id])
      halt [404, "App not found"]
    end
    erb :dashboard
  end
end
