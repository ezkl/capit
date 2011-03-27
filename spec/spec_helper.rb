# encoding: UTF-8
require 'simplecov'

SimpleCov.start do
  coverage_dir 'coverage'
  add_filter '/spec/'
end

require 'rspec'
require 'capit'
