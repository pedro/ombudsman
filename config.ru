require "rubygems"
require "bundler"

Bundler.require
require "./lib/ombudsman"

$stdout.sync = true

use Ombudsman::Drain
run Ombudsman::API