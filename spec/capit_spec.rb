# encoding: UTF-8
require 'spec_helper'

describe CapIt do
  context "Constants" do
    subject { CapIt::VERSION }
    it { should_not be_nil }
  end    
end
