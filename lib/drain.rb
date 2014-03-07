class Drain < Sinatra::Base
  post "/drain/:id/:secret" do |id, secret|
    if Cache.get("auth-#{id}") != secret
      halt 403
    end

    if req = Log.parse(id, secret, request.env["rack.input"].read)
      Cache.rpush "requests", MultiJson.encode(req.serialized)
    end
    ""
  end
end
