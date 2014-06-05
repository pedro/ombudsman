require "test_helper"

describe Health do
  before do
    @e = Endpoint.create
  end

  describe ".update" do
    it "sets status to gray when we don't have enough data" do
      Health.update(@e, {}, {})
      assert_equal "gray", @e.health
    end

    it "keeps the previous status when nothing happened in the last 5 mins" do
      @e.update(health: "red")
      Health.update(@e, {}, { 500 => 1 })
      assert_equal "red", @e.health
    end

    it "sets it to red when error rate is over 5%" do
      Health.update(@e, { 200 => 100, 500 => 6 }, {})
      assert_equal "red", @e.health
      assert_equal "5% errors", @e.health_msg
    end

    it "sets it too red when error rates are rising" do
      Health.update(@e, { 200 => 100, 500 => 4 }, { 200 => 100, 500 => 1 })
      assert_equal "red", @e.health
      assert_equal "error rate increased 2%", @e.health_msg
    end

    it "updates the endpoints stats with the last hour" do
      Health.update(@e, {}, { 200 => 1 })
      assert_equal({ 200 => 1 }, @e.stats)
    end
  end

  describe ".no_data?" do
    it "is true when we don't have stats for the window" do
      assert_equal true, Health.no_data?({})
    end

    it "is true when all values are zeroed" do
      assert_equal true, Health.no_data?(200 => 0, 500 => 0)
    end

    it "is false otherwise" do
      assert_equal false, Health.no_data?(200 => 1)
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
