require "test_helper"

describe Ombudsman::API do
  describe "POST /heroku/resources" do
    before do
      @params = {
        foo: "bar"
      }
      header "Content-Type", "application/json"
    end

    it "works" do
      post "/heroku/resources", MultiJson.encode(@params)
      assert_equal 200, last_response.status
      assert_equal "{}", last_response.body
    end
  end
end