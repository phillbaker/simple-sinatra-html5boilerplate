# This file is used by Rack-based servers to start the application.

$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'app.rb'
run App
