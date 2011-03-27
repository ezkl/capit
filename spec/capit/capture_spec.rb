# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CapIt::Capture do  
  describe "Convenience Method" do
    it "should have a Convenience Method" do
      @folder = Dir.pwd + '/spec/temporary'
      `mkdir #{@folder}`
      @capit = CapIt::Capture("http://mdvlrb.com/", :filename => 'mdvlrb.png', :folder => @folder).should == @folder + "/mdvlrb.png"
      `rm -rf #{@folder}`
    end
  end
  
  describe "Capture Class" do
    subject { CapIt::Capture.new("http://mdvlrb.com/", :filename => 'mdvlrb.png') }
    
    describe "#initialize" do
      it "should have defaults" do
        subject.folder.should == Dir.pwd
        subject.filename.should == "mdvlrb.png"
        subject.user_agent.should == "CapIt! [http://github.com/meadvillerb/capit]"
        subject.max_wait.should == 15000
      end

      it "should respond to input" do
        subject.should respond_to :url, :folder, :filename, :user_agent, :max_wait, :delay
      end
      
      it "should allow filename to be changed if extension is valid" do
        @capit = CapIt::Capture.new("http://mdvlrb.com/")
        @capit.filename = "mdvlrb.png"
        @capit.filename.should == "mdvlrb.png"
      end
    end
    
    describe "#capture" do
      before(:all) do
        @folder = Dir.pwd + '/spec/temporary'
        @capit = CapIt::Capture.new("http://mdvlrb.com/", :filename => 'mdvlrb.jpeg', :folder => @folder)
        `mkdir #{@folder}`
      end
      
      it "should return the full path to the screenshot" do
        @capit.capture.should == @folder + "/mdvlrb.jpeg"
      end
      
      it "should capture the proper screenshot" do
        @capit.output.should == @folder + "/mdvlrb.jpeg"
      end
      
      after(:all) do
        `rm -rf #{@folder}`
      end
    end
    
    describe "#capture_command" do
      it "should prefix xvfb when platform is Linux" do
        @capit = CapIt::Capture.new("http://mdvlrb.com/")
        RUBY_PLATFORM = "linux"
        @capit.capture_command.should match /^xvfb/
      end
      
      it "shouldn't prefix anything when platform is Mac" do
        @capit = CapIt::Capture.new("http://mdvlrb.com/")
        RUBY_PLATFORM = "darwin"
        @capit.capture_command.should match /^CutyCapt/
      end
      
    end
    
    describe "Errors" do
      
      it "should raise an error if CutyCapt isn't available" do
        path = ENV['PATH']
        expect { ENV['PATH'] = ""; CapIt::Capture.new("http://mdvlrb.com/") }.to raise_error(/CutyCapt/)
        ENV['PATH'] = path
      end
      
      it "should raise an error if OS isn't Linux or Mac" do
        RUBY_PLATFORM = "mingw"
        expect { subject.determine_os }.to raise_error(/platforms/)
        RUBY_PLATFORM = "darwin"
      end
      
      it "should not accept filenames without a valid extension" do
        expect { CapIt::Capture.new("http://mdvlrb.com/", :filename => 'capit.foo') }.to raise_error(/valid extension/)
        expect { subject.filename = "capit.foo" }.to raise_error(/valid extension/)
      end
    end
    
  end
end