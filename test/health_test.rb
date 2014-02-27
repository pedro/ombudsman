require "test_helper"

describe Health do
  before do
    @e = Endpoint.create
  end

  describe ".update" do
    it "updates the endpoints stats" do
      Health.update(@e, { 200 => 1 })
      assert_equal({ 200 => 1 }, @e.stats)
    end
  end
end
