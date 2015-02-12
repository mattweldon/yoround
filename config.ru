$: << File.expand_path(File.dirname(__FILE__))
require 'dotenv'
Dotenv.load(File.expand_path("../.env",  __FILE__))
require './web/app'
run App.new