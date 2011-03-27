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
        with_constants :RUBY_PLATFORM => "linux" do
          @capit = CapIt::Capture.new("http://mdvlrb.com/")
          @capit.capture_command.should match /^xvfb/
        end
      end
      
      it "shouldn't prefix anything when platform is Mac" do
        with_constants :RUBY_PLATFORM => "darwin" do
          @capit = CapIt::Capture.new("http://mdvlrb.com/")
          @capit.capture_command.should match /^CutyCapt/
        end
      end
      
    end
    
    describe "Errors" do
      it "should raise an error if CutyCapt isn't available" do
        with_environment_variable 'PATH' => "" do
          expect { CapIt::Capture.new("http://mdvlrb.com/") }.to raise_error(/CutyCapt/)
        end
      end
      
      it "should raise an error if OS isn't Linux or Mac" do
        with_constants :RUBY_PLATFORM => "mingw" do
          expect { subject.determine_os }.to raise_error(/platforms/)
        end
      end
      
      it "should not accept filenames without a valid extension" do
        expect { CapIt::Capture.new("http://mdvlrb.com/", :filename => 'capit.foo') }.to raise_error(/valid extension/)
        expect { subject.filename = "capit.foo" }.to raise_error(/valid extension/)
      end
    end
  end
end