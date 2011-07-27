# encoding: utf-8
module Rack
  class Webconsole
    # A sandbox to evaluate Ruby in. It is responsible for retrieving local
    # variables stored in `@locals`, and resetting the environment.
    #
    class Sandbox
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
