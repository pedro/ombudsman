require "rubygems"
require "bundler"

Bundler.require
require "./lib/ombudsman"

$stdout.sync = true
run Ombudsman::API
