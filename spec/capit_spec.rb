require 'spec_helper'

describe CapIt do
  
  describe "Basic Module" do
    it "should have a VERSION" do
      CapIt::VERSION.should_not be_nil
    end
  end
end