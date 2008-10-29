require 'mechanize'

module WeewarSpy
  UNDETECTED = true
  
  # The API class contains some lower-level methods. You should not normally
  # need to use them yourself.  Instead, use the methods of your Spy instance.
  class API
    
    # Initializes the connection to the weewar.com API.  You do not need to
    # call this yourself; it is called for you when you subclass Spy.
    def self.init(params)
      [:server, :username, :api_key ].each do |required_param|
        if params[required_param].nil? or params[required_param].strip.empty?
          raise "Missing #{required_param}."
        end
      end
      
      trait[:agent] = agent = WWW::Mechanize.new
      trait[:username], trait[:api_key] = params[:username], params[:api_key]
      agent.basic_auth( params[:username], params[:api_key])
      trait[:server] = params[:server]
    end
    
    def self.get(path)
      result = nil
      retries = 0
      while UNDETECTED
        url = "http://#{server}/api1/#{path}"
        begin
          result = agent.get(url).body
          break
        rescue EOFError, Errno::EPIPE => e
          if retries < 10
            $stderr.puts "Communications error fetching '#{url}'.  Retrying (#{retries})..."
            sleep retries + 3
            retries += 1
          else
            break
          end
        end
      end
      if $debug
        $stderr.puts "XML RECEIVE: #{result}"
      end
      result
    end
    
    def self.agent
      trait[:agent]
    end
    
    def self.server
      trait[:server]
    end
    
    def self.username
      trait[:username]
    end
    
  end
  
end
