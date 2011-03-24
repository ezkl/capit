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
  
  class Capture
    # The URL of the page to be captured
    attr_reader   :url
    
    
    attr_accessor :folder, :filename, :user_agent, :max_wait, 
                  :delay, :output
    
    # Initialize a new Capture
    #
    # @example
    #   capit = CapIt::Capture.new("http://mdvlrb.com", :filename => "mdvlrb.png")
    #   capit.max_wait = 5000
    #   capit.folder = "/home/user/screenshots"
    #
    def initialize url, options = {}
      @url        = PostRank::URI.clean(url)              
      @folder     = options[:folder] || Dir.pwd
      @filename   = options[:filename] || "capit.jpg"
      @user_agent = options[:user_agent] || "CapIt! [http://github.com/meadvillerb/capit]"
      @max_wait   = options[:max_wait] || 15000
      @delay      = options[:delay]
    end
    
    # Performs the page capture.
    # 
    # @example
    #   capit = CapIt::Capture.new("http://mdvlrb.com", :filename => "mdvlrb.png", :folder => "/home/user/screenshots")
    #   capit.capture
    #
    # @return [true, false]
    # 
    def capture      
      `#{capture_command}`
      successful?
    end

    protected
    
      # Determines whether the capture was successful
      # by checking for the existence of the output file.
      # Sets {@output} if true.
      #
      # @return [true, false]
      #
      def successful?
        if FileTest.exists?("#{@folder}/#{@filename}")
          @output = "#{@folder}/#{@filename}"
          true
        else
          false
        end  
      end
      
      # Produces the command used to run CutyCapt. 
      # 
      # @return [String]
      #
      def capture_command        
        cmd = "CutyCapt"
        cmd += " --url='#{@url}'"
        cmd += " --out='#{@folder}/#{@filename}'"
        cmd += " --max-wait=#{@max_wait}"
        cmd += " --delay=#{@delay}" if @delay
        cmd += " --user-agent='#{@user_agent}'"
        
        if determine_os == :linux
          xvfb = 'xvfb-run --server-args="-screen 0, 1024x768x24" '
          xvfb.concat(cmd)
        else
          cmd
        end        
      end
      
      # Uses RUBY_PLATFORM to determine the operating system.
      # Not foolproof, but good enough for the time being.
      # 
      # @return [Symbol]
      # 
      def determine_os
        case RUBY_PLATFORM
          when /darwin/ then :mac
          when /linux/ then :linux
          else :error
        end
      end
  end
end