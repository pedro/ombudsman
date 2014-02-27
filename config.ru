require "rubygems"
require "bundler"

Bundler.require
require "./lib/ombudsman"

$stdout.sync = true

use Drain
run API