ENV["DATABASE_URL"] = "postgres://localhost/ombudsman-test"
ENV["LOG_DRAIN_URL"] = "http://localhost:3000/drain"
ENV["HEROKU_USERNAME"] = "ombudsman"
ENV["HEROKU_PASSWORD"] = "secret"
ENV["RACK_ENV"] = "test"

require "rubygems"
require "bundler"

Bundler.require(:default, :test)

require "minitest/spec"
require "minitest/autorun"
require "./lib/ombudsman"

class MiniTest::Spec
  include Rack::Test::Methods

  def app
    Ombudsman::API
  end

  def last_json
    @last_json ||= MultiJson.decode(last_response.body)
  end
end
