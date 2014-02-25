require "test_helper"

describe Ombudsman::API do
  describe "POST /heroku/resources" do
    before do
      @params = {
        foo: "bar"
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
    end
  end
end