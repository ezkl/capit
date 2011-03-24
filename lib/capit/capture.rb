require 'postrank-uri'

module CapIt
  ###
  # Screen Capture URL. Convenience method for CapIt::Capture.new(opts).capture
  class << self
    def Capture url, options = {}
      CapIt::Capture.new(url, options).capture
    end
  end
  
  class Capture
    attr_reader   :url
    attr_accessor :folder, :filename, :user_agent, :max_wait, :delay
    
    def initialize url, options = {}
      @url        = PostRank::URI.clean(url)              
      @folder     = options[:folder] || Dir.pwd
      @filename   = options[:filename] || "capit.jpg"
      @user_agent = options[:user_agent] || "CapIt! [http://github.com/meadvillerb/capit]"
      @max_wait   = options[:max_wait] || 15000
      @delay      = options[:delay]
    end
  
    def capture      
      `#{capture_command}`
      FileTest.exists?("#{@folder}/#{@filename}")
    end

    protected      
      def determine_os
        case RUBY_PLATFORM
          when /darwin/ then :mac
          when /linux/ then :linux
          else :error
        end
      end
      
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
  end
end