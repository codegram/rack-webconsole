# encoding: utf-8
module Rack
  class Webconsole
    # A sandbox to evaluate Ruby in. It is responsible for retrieving local
    # variables stored in `@locals`, and resetting the environment.
    #
    class Sandbox
      # Initialize class variables.
      def initialize(options={})
        @password = options.fetch(:console_password, Rack::Webconsole.console_password)
        @authenticated = false
      end
      
      # @return [TrueClass/FalseClass] is the current console user authenticated?
      def authenticated?
        @authenticated == true || @password.nil?
      end
      
      # Authenticates the password passed from the console.
      #
      # @return [TrueClass/FalseClass] the result of the authentication
      def authenticate(password_to_check)
        return @authenticated = (password_to_check == @password)
      end

      # Catches all the undefined local variables and tries to retrieve them
      # from `@locals`. If it doesn't find them, it falls back to the default
      # method missing behavior.
      def method_missing(method, *args, &block)
        @locals ||= {}
        @locals[method.to_sym] || super(method, *args, &block)
      end

      # Makes the console use a fresh, new {Sandbox} with all local variables
      # resetted.
      #
      # @return [String] 'ok' to make the user notice.
      def reload!
        $sandbox = Sandbox.new
        'ok'
      end

      # Returns the current page request object for inspection purposes.
      #
      # @return [Rack::Request] the current page request object.
      def request
        Webconsole::Repl.request
      end
    end
  end
end
