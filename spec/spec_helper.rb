# encoding: UTF-8
require 'simplecov'
SimpleCov.start do
  coverage_dir 'coverage'
  add_filter 'spec/'
end

Dir[File.expand_path('support', File.dirname(__FILE__)) + "/**/*.rb"].each { |f| require f }
require 'capit'
