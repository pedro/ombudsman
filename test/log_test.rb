require "test_helper"

describe Log do
  describe ".parse" do
    it "drops logs not coming from the router" do
      assert_equal false, Log.parse(1, "abc", "raw")
    end

    it "parses logs into requests" do
      raw = '241 <158>1 2014-02-25T08:42:07.784181+00:00 host heroku router - at=info method=GET path=/ host=pedro-dev.herokuapp.com request_id=ccdec783-b755-4b25-802e-00b1f99ee357 fwd="199.21.84.17" dyno=web.1 connect=2ms service=22ms status=200 bytes=5077'
      req = Log.parse(1, "abc", raw)
      assert_equal "get", req.verb
    end
  end
end
