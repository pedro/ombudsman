require "test_helper"

describe Endpoint do
  it "starts as gray/no data" do
    e = Endpoint.create
    assert_equal "gray", e.health
    assert_equal "not enough data", e.health_msg
  end
end