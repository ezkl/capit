# encoding: UTF-8
require 'simplecov'

SimpleCov.start do
  coverage_dir 'coverage'
  add_filter 'spec/'
end

require 'rspec'
require 'support/with_constants'
require 'support/deferred_garbage_collection' # http://makandra.com/notes/950-speed-up-rspec-by-deferring-garbage-collection
require 'support/temporary_folder_helper'

require 'capit'
