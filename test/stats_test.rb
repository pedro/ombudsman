require "test_helper"

describe Stats do
  before do
    @e = Endpoint.new()
    stub(@e).id { 42 }
  end

  describe ".record" do
    it "accumulates a count of status codes in a window" do
      Timecop.freeze(Time.mktime(2014, 1, 1, 12, 00)) do
        Stats.record(@e, 200)
        Stats.record(@e, 200)
        Stats.record(@e, 500)
      end
      Timecop.freeze(Time.mktime(2014, 1, 1, 12, 01)) do
        Stats.record(@e, 500)
        Stats.record(@e, 503)
      end

      assert_equal 2, Cache.hget("42:0", "200").to_i
      assert_equal 1, Cache.hget("42:0", "500").to_i
      assert_equal 1, Cache.hget("42:1", "500").to_i
      assert_equal 1, Cache.hget("42:1", "503").to_i
    end

    it "expires these keys so we reset the count for the next window" do
      Timecop.freeze(Time.mktime(2014, 1, 1, 12, 00)) do
        Stats.record(@e, 200)
      end
      assert_equal 3600, Cache.ttl("42:0")
    end
  end

  describe ".summary" do
    it "returns the accumulated status for the specified window" do
      Cache.hset("42:0", "200", 4)
      Cache.hset("42:0", "500", 2)
      Cache.hset("42:1", "200", 1)
      Cache.hset("42:4", "500", 1)
      Timecop.freeze(Time.mktime(2014, 1, 1, 12, 5)) do
        assert_equal({ 200 => 5, 500 => 3 }, Stats.summary(@e, 5))
      end
    end

    it "wraps around" do
      Cache.hset("42:0", "200", 1)
      Cache.hset("42:59", "200", 1)
      Timecop.freeze(Time.mktime(2014, 1, 1, 12, 0)) do
        assert_equal({ 200 => 2 }, Stats.summary(@e, 1))
      end
    end
  end
end
