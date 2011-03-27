# encoding: UTF-8

# Primary namespace of the capit gem
module CapIt
  
  # Raised when OS isn't Linux or Mac
  class InvalidOSError < StandardError; end

  # Raised when a filename with an invalid extension is entered.
  # @abstract
  class InvalidExtensionError < StandardError; end
  
end

require 'capit/version'
require 'capit/capture'