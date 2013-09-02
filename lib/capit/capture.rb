# encoding: UTF-8

module CapIt
  class << self
    
    # Capture image from URL. Convenience method for {CapIt::Capture}
    # 
    # @example
    #   CapIt::Capture("http://mdvlrb.com", :filename => "mdvlrb.jpg")
    #
    def Capture url, options = {}
      CapIt::Capture.new(url, options).capture
    end
  end
  
  # This class provides the screen capture functionality.
  #
  # @example
  #   capit = CapIt::Capture.new("http://mdvlrb.com", :filename => "mdvlrb.png")
  #   capit.max_wait = 5000
  #   capit.folder = "/home/user/screenshots"
  #   capit.capture
  #   capit.output = "/home/user/screenshots/mdvlrb.png"
  #
  class Capture
    
    # All extensions CutyCapt can use to infer format of output
    EXTENSIONS = /\A[\w\-\.]+\.(svg|ps|pdf|itext|html|rtree|png|jpeg|jpg|mng|tiff|gif|bmp|ppm|xvm|xpm)\z/i
    
    # The URL of the page to be captured
    attr_reader   :url
    
    attr_accessor :folder, :filename, :user_agent, :max_wait, :delay, :output, :cutycapt_path, :min_width, :min_height
    
    # Initialize a new Capture
    # @param [String] url The URL we want to capture.
    # @param [Hash] options Various options we can set.
    #
    # @return [Object]
    #
    # @see CapIt::Capture#cutycapt_installed?
    # @see CapIt::Capture#valid_extension?
    #
    # @raise CutyCaptError
    # @raise InvalidExtensionError
    #
    def initialize url, options = {}
      @url            = url              
      @folder         = options[:folder] || Dir.pwd
      @filename       = options[:filename] || "capit.jpeg"
      @user_agent     = options[:user_agent] || "CapIt! [http://github.com/meadvillerb/capit]"
      @max_wait       = options[:max_wait] || 15000
      @delay          = options[:delay]
      @cutycapt_path  = options[:cutycapt_path] || determine_cutycapt_path
      @min_width      = options[:min_width] || 1024
      @min_height     = options[:min_height] || 768
            
      valid_extension?(@filename)
    end
    
    # Performs the page capture.
    # 
    # @example
    #   capit = CapIt::Capture.new("http://mdvlrb.com", :filename => "mdvlrb.png", :folder => "/home/user/screenshots")
    #   capit.capture
    #
    # @return [String, false]
    # 
    # @see CapIt::Capture#successful? 
    #
    def capture      
      `#{capture_command}`

      # Note: builds an extra string (since `output_exists?` also calls
      # `expected_output_path`) but it'll be just fine for now.
      if output_exists?
        @output = expected_output_path
      else
        @output = nil
      end
      # Not strictly necessary, but I want to make it clear that `capture`
      # has the same return value as `output`
      @output
    end
    
    # Overloads #filename= to ensure that filenames have valid extensions.
    #
    # @param [String] filename
    # @see CapIt::Capture#valid_extension?
    # 
    def filename=(filename)
      valid_extension?(filename)
      @filename = filename 
    end
    
    # Compares filename against EXTENSIONS. Raises InvalidExtensionError if the extension is invalid.
    # 
    # @param [String] filename
    #
    def valid_extension?(filename)
      raise InvalidExtensionError, "You must supply a valid extension!" if filename[EXTENSIONS].nil?
    end
  
    # Determines whether the capture was successful
    # by checking for the existence of the output file.
    # Sets CapIt::Capture#output if true.
    #
    # @return [String, false]
    #
    def successful?
      output_exists? && expected_output_path
    end
    
    # Produces the command used to run CutyCapt. 
    # 
    # @return [String]
    #
    def capture_command        
      cmd = "#{@cutycapt_path} --url='#{@url}'"
      cmd += " --out='#{@folder}/#{@filename}'"
      cmd += " --max-wait=#{@max_wait}"
      cmd += " --delay=#{@delay}" if @delay
      cmd += " --user-agent='#{@user_agent}'"
      cmd += " --min-width='#{@min_width}'"
      cmd += " --min-height='#{@min_height}'"

      
      if determine_os == :linux and check_xvfb
        xvfb = 'xvfb-run --server-args="-screen 0, 1024x768x24" '
        xvfb.concat(cmd)
      else
        if check_cutycapt
          cmd
        else
          raise "Required package CutyCapt is not installed."
        end
      end       
    end
    
    def check_xvfb
      !(`which xvfb-run`.empty?)
    end
    
    def determine_cutycapt_path
      which_path('CutyCapt') or which_path('cutycapt')
    end
    
    # Uses RUBY_PLATFORM to determine the operating system.
    # Not foolproof, but good enough for the time being.
    # 
    # @return [Symbol]
    # @raise [InvalidOSError]
    # 
    def determine_os
      case RUBY_PLATFORM
        when /darwin/i then :mac
        when /linux/i then :linux
        else raise InvalidOSError, "CapIt currently only works on the Mac and Linux platforms"
      end
    end

  private
    # A helper to keep `determine_cutycapt_path` simple and to make future
    # mocking/stubbing needs easier.
    # TODO: `.strip` call may be superfluous
    def which_path(bin_name)
      bin_path = `which #{bin_name}`.strip
      bin_path.empty? ? nil : bin_path
    end

    def output_exists?
      FileTest.exists?(expected_output_path)
    end

    def expected_output_path
      File.join(@folder, @filename)
    end
  end
end
