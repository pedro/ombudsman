require "test_helper"

describe Log do
  describe ".parse" do
    it "drops logs not coming from the router" do
      assert_equal false, Log.parse(1, "abc", "raw")
    end

    it "parses logs into requests" do
      raw = '241 <158>1 2014-02-25T08:42:07.784181+00:00 host heroku router - at=info method=GET path=/foo host=pedro-dev.herokuapp.com request_id=ccdec783-b755-4b25-802e-00b1f99ee357 fwd="199.21.84.17" dyno=web.1 connect=2ms service=22ms status=200 bytes=5077'
      req = Log.parse(1, "abc", raw)
      assert_equal 1, req.app_id
      assert_equal "abc", req.secret
      assert_equal "get", req.verb
      assert_equal "/foo", req.path
      assert_equal 200, req.status
    end
  end
end
