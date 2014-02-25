require "test_helper"

describe Aggregator do
  before do
    @app = App.create
    @agg = Aggregator.new(@app, [])
  end

  describe "#group!" do
    # /foo/1
    # /foo/2
    # /bar

    it "creates endpoints for the different paths" do
      @agg.requests << Request.new(path: "/foo")
      @agg.requests << Request.new(path: "/bar")
      @agg.work!
      assert_equal %w( /bar /foo ), @app.endpoints.map(&:signature).sort
    end
  end
end
