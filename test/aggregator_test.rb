require "test_helper"

describe Aggregator do
  before do
    @app = App.create
  end

  describe "#group!" do
    it "creates an endpoint for simple paths" do
      @agg = Aggregator.new(@app, Request.new(path: "/foo"))
      @agg.work!
      assert_equal %w( /foo ), @app.endpoints.map(&:signature)
    end

    it "reuses endpoints with the same signature" do
      Endpoint.create(app: @app, signature: "/foo/\\d+")
      @agg = Aggregator.new(@app, Request.new(path: "/foo/42"))
      endpoint = @agg.work!
      assert_equal %w( /foo/\d+ ), @app.endpoints.map(&:signature).sort
    end
  end
end
