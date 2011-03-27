# encoding: UTF-8
require 'simplecov'

SimpleCov.start do
  coverage_dir 'coverage'
  add_filter 'spec/'
end

require 'rspec'

require 'support/with_constants'

# http://makandra.com/notes/950-speed-up-rspec-by-deferring-garbage-collection
require 'support/deferred_garbage_collection'
RSpec.configure do |config|
  config.before(:all) do
    DeferredGarbageCollection.start
  end
  
  config.after(:all) do
    DeferredGarbageCollection.reconsider
  end
end

require 'capit'
