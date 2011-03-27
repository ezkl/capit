# -*- encoding: utf-8 -*-

begin
  require 'simplecov'
  SimpleCov.start do
    coverage_dir 'coverage'
    add_filter '/spec/'
  end
rescue LoadError
end

require 'growl'
require 'capit'
