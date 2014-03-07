require "test_helper"

describe Aggregator do
  before do
    @app = App.create
  end

  describe "#group!" do
    it "creates an endpoint for simple paths" do
      @agg = Aggregator.new(@app, Request.new(verb: "get", path: "/foo"))
      endpoint = @agg.work!
      assert_equal "get", endpoint.verb
      assert_equal "/foo", endpoint.signature
    end

    it "reuses endpoints with the same signature" do
      Endpoint.create(app: @app, verb: "get", signature: "/foo/*")
      @agg = Aggregator.new(@app, Request.new(verb: "get", path: "/foo/42"))
      endpoint = @agg.work!
      assert_equal %w( /foo/* ), @app.endpoints.map(&:signature).sort
    end
  end
end
