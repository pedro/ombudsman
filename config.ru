require "rubygems"
require "bundler"

Bundler.require
require "./lib/ombudsman"

$stdout.sync = true

use Drain
use API
run SSO
