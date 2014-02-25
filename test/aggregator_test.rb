require "test_helper"

describe Aggregator do
  before do
    @app = App.create
    @agg = Aggregator.new(@app, [])
  end

  describe "#group!" do
    it "creates endpoints for the different paths" do
      @agg.requests << Request.new(path: "/foo")
      @agg.requests << Request.new(path: "/bar")
      @agg.work!
      assert_equal %w( /bar /foo ), @app.endpoints.map(&:signature).sort
    end

    it "groups what seems to be repeated ids into the same signature" do
      @agg.requests << Request.new(path: "/foo/1")
      @agg.requests << Request.new(path: "/foo/2")
      @agg.work!
      assert_equal %w( /foo/* ), @app.endpoints.map(&:signature).sort
    end

    it "replaces multiple ids" do
      @agg.requests << Request.new(path: "/foo/1/bar/1")
      @agg.requests << Request.new(path: "/foo/1/bar/2")
      @agg.requests << Request.new(path: "/foo/2")
      @agg.work!
      assert_equal %w( /foo/* /foo/*/bar/* ), @app.endpoints.map(&:signature).sort
    end
  end
end
