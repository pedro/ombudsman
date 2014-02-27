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

  post "/sso/login" do
    t = Time.at(params[:timestamp].to_i)
    signature = [params[:id], ENV["SSO_SALT"], t.to_i].join(":")
    token = Digest::SHA1.hexdigest(signature)

    if token != params[:token] || t < Time.now - 120
      halt [403, "Invalid SSO request"]
    end

    session[:app_id] = params[:id]
    response.set_cookie('heroku-nav-data', value: params['nav-data'])
    redirect "/dashboard"
  end

  get "/dashboard" do
    unless @app = App.find(id: session[:app_id])
      halt [404, "Session expired"]
    end
    erb :dashboard
  end
end
