require "test_helper"

describe App do
  it "generates a drain secret" do
    app = App.create
    assert_equal 16, app.drain_secret.size
  end
end