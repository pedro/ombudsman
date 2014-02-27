require "test_helper"

describe Health do
  before do
    @e = Endpoint.create
  end

  describe ".update" do
    it "sets status to gray when we don't have enough data" do
      Health.update(@e, {})
      assert_equal "gray", @e.health
    end

    it "updates the endpoints stats" do
      Health.update(@e, { 200 => 1 })
      assert_equal({ 200 => 1 }, @e.stats)
    end
  end

  describe ".compute_error_rate" do
    it "returns 0 if there are no requests" do
      assert_equal 0, Health.compute_error_rate({})
    end

    it "returns the % of 50x requests" do
      assert_equal 10, Health.compute_error_rate(200 => 9, 500 => 1)
      assert_equal 100, Health.compute_error_rate(503 => 1)
    end
  end
end
