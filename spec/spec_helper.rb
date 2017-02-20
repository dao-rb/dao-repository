require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rspec/its'

require 'dao/repository'
require 'dao/gateway'
