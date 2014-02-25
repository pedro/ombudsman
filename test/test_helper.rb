ENV["HEROKU_USERNAME"] = "ombudsman"
ENV["HEROKU_PASSWORD"] = "secret"

require "rubygems"
require "bundler"

Bundler.require(:default, :test)

require "minitest/spec"
require "minitest/autorun"
require "sinatra"
require "./lib/ombudsman"

class MiniTest::Spec
  include Rack::Test::Methods

  def app
    Ombudsman::API
  end
end
