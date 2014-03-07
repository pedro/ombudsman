require "test_helper"

describe "lame slow ass log drain" do
  def app
    Drain
  end

  it "authenticates" do
    post "/drain/1234/secret", "foo"
    assert_equal 403, last_response.status
  end

  it "drops invalid logs" do
    Cache.set("auth-1234", "secret")
    post "/drain/1234/secret", "bad"
    assert_equal 200, last_response.status
    assert_equal 0, Cache.llen("requests")
  end

  it "authenticates" do
    Cache.set("auth-1234", "secret")
    raw = '241 <158>1 2014-02-25T08:42:07.784181+00:00 host heroku router - at=info method=GET path=/foo host=pedro-dev.herokuapp.com request_id=ccdec783-b755-4b25-802e-00b1f99ee357 fwd="199.21.84.17" dyno=web.1 connect=2ms service=22ms status=200 bytes=5077'
    post "/drain/1234/secret", raw
    assert_equal 200, last_response.status
    assert_equal 1, Cache.llen("requests")
  end
end