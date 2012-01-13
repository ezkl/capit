# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CapIt do  
  it "should have a Convenience Method" do
    @folder = setup_temporary_folder
    @capit = CapIt::Capture("http://mdvlrb.com/", :filename => 'one.test-mdvlrb.png', :folder => @folder).should == @folder + "/one.test-mdvlrb.png"
    destroy_temporary_folder(@folder)
  end
    
  describe CapIt::Capture do
    before { @capit = CapIt::Capture.new("http://mdvlrb.com/") }
    subject { @capit }
    
    describe "#initialize" do
      it { should respond_to :url, :folder, :filename, :user_agent, :max_wait, :delay, :cutycapt_path }
      
      context "defaults" do
        specify { @capit.folder.should == Dir.pwd }
        specify { @capit.filename.should == "capit.jpeg" }
        specify { @capit.user_agent.should == "CapIt! [http://github.com/meadvillerb/capit]" }
        specify { @capit.max_wait.should == 15000 }
      end
    end
    
    describe ":filename" do
      context "when valid" do
        before { @capit.filename = "mdvlrb.png" }
        specify { @capit.filename.should == "mdvlrb.png" }
      end
      
      context "when invalid" do
        it "should raise an error" do
          expect { @capit.filename = "capit.foo" }.to raise_error(/valid extension/)
        end
      end
    end
    
    
    describe "#capture" do
      before(:all) do
        @folder = setup_temporary_folder
        @capture = CapIt::Capture.new("http://mdvlrb.com", :folder => @folder)
      end

      context "when screen capture is successful" do
        specify { @capture.capture.should == @folder + "/capit.jpeg" }
        specify { @capture.output.should == @folder + "/capit.jpeg" }
      end
            
      after(:all) do
        destroy_temporary_folder(@folder)
      end
    end
    
    describe "#cutycapt_path=" do
      it "should allow the user to set CutyCapt's path" do
        capit = CapIt::Capture.new("http://mdvlrb.com/")
        capit.cutycapt_path = "/usr/local/sbin/CutyCapt"
        capit.cutycapt_path.should == "/usr/local/sbin/CutyCapt"
      end
    end
    
    describe "#determine_cutycapt_path" do
      it "should determine the appropriate path for the executable if possible" do
        @capit.determine_cutycapt_path.should == "/usr/local/bin/CutyCapt"
      end
    end
    
    describe "#capture_command" do
      before { @capit = CapIt::Capture.new("http://mdvlrb.com/") }
      subject { @capit }
    
      context "when platform is Linux" do
        it "should add the xvfb prefix" do
          with_constants :RUBY_PLATFORM => "linux" do
            @capit.capture_command.should match /^xvfb/
          end
        end
      end
    
      context "when platform is Mac" do
        it "should not add the xvfb prefix" do
          with_constants :RUBY_PLATFORM => "darwin" do 
            @capit.capture_command.should match /CutyCapt/
          end
        end
      end  
    end
    
    describe "Fatal Errors" do
      context "when platform is unknown" do
        it "should raise an error" do
          with_constants :RUBY_PLATFORM => "mingw" do
           expect { @capit.determine_os }.should raise_error(/platforms/)
          end
        end
      end
    end    
  end
end