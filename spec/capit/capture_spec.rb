# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CapIt do  
  it "provides a Capture method that creates a Capture object and calls `#capture`" do
    cap_url = cap_opts = nil
    mock_capture = mock('capture')
    # Create a mock instead of a real Capture object
    CapIt::Capture.stub(:new) do |url, opts|
      cap_url = url
      cap_opts = opts
      mock_capture
    end
    mock_capture.should_receive(:capture).and_return('sure did')

    CapIt::Capture("http://mdvlrb.com/", :a1 => 'foo', :a2 => 'bar').should == 'sure did'
    cap_url.should == 'http://mdvlrb.com/'
    cap_opts.should == {
      :a1 => 'foo',
      :a2 => 'bar'
    }
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
        specify { @capit.min_width.should == 1024 }
        specify { @capit.min_height.should == 768 }
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
      before do
        @capit.cutycapt_path = '/usr/local/sbin/cutyCapt'
        @capit.folder = '/tmp/blah'
        @capit.filename = 'cap_output.png'
      end

      context "when screen capture is successful" do
        it "returns the full path of the output" do
          # Travis runs on linux, so you're going to need to stub this for now
          @capit.stub(:check_xvfb => true)
          # Ensure that we're invoking the shell command, but let's not
          # actually invoke it.
          @capit.should_receive(:`).with(@capit.capture_command).and_return('')
          FileTest.stub(:exists?).with('/tmp/blah/cap_output.png').and_return(true)

          @capit.capture.should == '/tmp/blah/cap_output.png'
          @capit.output.should == '/tmp/blah/cap_output.png'
        end
      end

      context "when the screen capture is not successful" do
        it "returns nil" do
          # Travis runs on linux, so you're going to need to stub this for now
          @capit.stub(:check_xvfb => true)
          # Ensure that we're invoking the shell command, but let's not
          # actually invoke it.
          @capit.should_receive(:`).with(@capit.capture_command).and_return('')
          FileTest.stub(:exists?).with('/tmp/blah/cap_output.png').and_return(false)

          @capit.capture.should == nil
          @capit.output.should == nil
        end

        it "does not point to a previous capture's output" do
          # We've tested the precise invocation in other places, we don't
          # need that here.
          @capit.stub(:` => '')
          FileTest.stub(:exists?).with('/tmp/blah/cap_output.png').and_return(true)
          FileTest.stub(:exists?).with('/tmp/blah/out2.png').and_return(false)
          @capit.capture.should_not == nil
          @capit.output.should_not == nil

          @capit.filename = 'out2.png'
          @capit.capture.should == nil
          @capit.output.should == nil
        end
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
      it "looks for CutyCapt in the path" do
        @capit.stub(:`).with('which CutyCapt').and_return('/usr/local/bin/CutyCapt')
        @capit.stub(:`).with('which cutycapt').and_return('/usr/bin/cutycapt')
        @capit.determine_cutycapt_path.should == '/usr/local/bin/CutyCapt'
      end

      it "looks for cutycapt in the path when CutyCapt isn't available" do
        @capit.stub(:`).with('which CutyCapt').and_return('')
        @capit.stub(:`).with('which cutycapt').and_return('/usr/bin/cutycapt')
        @capit.determine_cutycapt_path.should == '/usr/bin/cutycapt'
      end

      it "may want to do something when a CutyCapt binary isn't found"
    end
    
    describe "#capture_command" do
      before do
        # Let's use a very different path to ensure the commands
        # are being built properly
        @capit.cutycapt_path = '/opt/bin/cutyCapt'
      end
      subject { @capit }
    
      context "when platform is Linux" do
        it "should add the xvfb prefix if xvfb-run available" do
          @capit.stub(:check_xvfb).and_return(true)
          with_constants :RUBY_PLATFORM => "linux" do
            @capit.capture_command.should match /^xvfb/
          end
        end
        
        it 'should not add the xvfb prefix if xvfb-run not available' do
          @capit.stub(:check_xvfb).and_return(false)
          with_constants :RUBY_PLATFORM => "linux" do
            @capit.capture_command.should_not match /^xvfb/
          end
        end
      end
    
      context "when platform is Mac" do
        it "should not add the xvfb prefix" do
          # To ensure that the omission of xvfb is a result of platform
          # detection and *not* a result of xvfb not being available
          @capit.stub(:check_xvfb).and_return(true)
          with_constants :RUBY_PLATFORM => "darwin" do 
            @capit.capture_command.should match /^\/opt\/bin\/cutyCapt/
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
