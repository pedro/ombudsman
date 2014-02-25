require "test_helper"

describe Ombudsman::API do
  describe "POST /heroku/resources" do
    before do
      @params = {
        heroku_id: "app123@heroku.com"
      }
      header "Content-Type", "application/json"
    end

    it "authenticates" do
      post "/heroku/resources", MultiJson.encode(@params)
      assert_equal 401, last_response.status
    end

    it "creates a new app" do
      authorize "ombudsman", "secret"
      post "/heroku/resources", MultiJson.encode(@params)
      assert_equal 200, last_response.status
      app = App.first(id: last_json["id"])
      assert_equal "app123@heroku.com", app.heroku_id
    end

    it "renders drain info" do
      authorize "ombudsman", "secret"
      post "/heroku/resources", MultiJson.encode(@params)
      assert_equal 200, last_response.status
      app = App.first(id: last_json["id"])
      assert_equal app.log_drain_url, last_json["syslog_drain_url"]
    end
  end

  describe "DELETE /heroku/resources" do
    before do
      @app = App.create
    end

    it "authenticates" do
      delete "/heroku/resources/#{@app.id}"
      assert_equal 401, last_response.status
    end

    it "renders a 404 if app doesn't exist" do
      authorize "ombudsman", "secret"
      delete "/heroku/resources/1234"
      assert_equal 404, last_response.status
    end

    it "deletes the app" do
      authorize "ombudsman", "secret"
      delete "/heroku/resources/#{@app.id}"
      assert_equal 200, last_response.status
      assert_equal nil, App.find(id: @app.id)
    end
  end
end