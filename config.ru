require "rubygems"
require "bundler"

Bundler.require
require "./lib/ombudsman"
run Ombudsman::API
