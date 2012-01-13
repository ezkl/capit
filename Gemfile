# encoding: UTF-8

source "http://rubygems.org"

group :test do
  gem 'rspec'
  gem 'yard'
  gem 'simplecov', :require => false
  gem 'guard'
  gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
  gem 'growl'
  gem 'guard-bundler'
  gem 'guard-rspec'
end

gemspec
