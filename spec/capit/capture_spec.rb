require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CapIt::Capture do  
  # Need to figure out how to test this.
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
        subject.should respond_to :url
        subject.should respond_to :folder
        subject.should respond_to :filename
        subject.should respond_to :user_agent
        subject.should respond_to :max_wait
        subject.should respond_to :delay
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
        @capit.capture_command.should match /xvfb/
      end
      
      it "shouldn't prefix anything when platform is Mac" do
        @capit = CapIt::Capture.new("http://mdvlrb.com/")
        RUBY_PLATFORM = "darwin"
        @capit.capture_command.should match /^CutyCapt/
      end
      
    end
    
    describe "Exceptions" do
      it "should raise an error if OS isn't Linux or Mac" do
        RUBY_PLATFORM = "mingw"
        CapIt::Capture.new("http://mdvlrb.com/").should raise_error
      end
      
      it "should not accept filenames without a valid extension" do
        lambda {CapIt::Capture.new("http://mdvlrb.com/", :filename => 'capit.foo')}.should raise_error
        lambda {subject.filename = "capit.foo"}.should raise_error
      end
    end
  end
end