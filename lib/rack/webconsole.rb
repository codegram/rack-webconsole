# encoding: utf-8
require 'rack/webconsole/repl'
require 'rack/webconsole/asset_helpers'
require 'rack/webconsole/assets'
require 'rack/webconsole/sandbox'

require 'rack/webconsole/railtie' if defined?(Rails::Railtie)

# Rack is a modular webserver interface written by Christian Neukirchen.
#
# Learn more at: https://github.com/rack/rack
#
module Rack
  # {Rack::Webconsole} is a Rack middleware that provides an interactive
  # console à la Rails console, but for any kind of Rack application (Rails,
  # Sinatra, Padrino...), accessible from your web application's front-end.
  #
  # For every request, it normally passes control to the {Assets} middleware,
  # which injects needed JavaScript, CSS and HTML code for the console to work
  # properly.
  #
  # It also exposes a special route used by the {Repl}, a Ruby evaluator which
  # is responsible of keeping state between requests, remembering local
  # variables and giving a true IRB-esque experience.
  #
  class Webconsole
    @@inject_jquery = false
    @@console_password = nil
    
    class << self
      # Returns whether the Asset injecter must inject JQuery or not.
      #
      # @return [Boolean] whether to inject JQuery or not.
      def inject_jquery
        @@inject_jquery
      end

      # Sets whether the Asset injecter must inject JQuery or not.
      #
      # @param [Boolean] value whether to inject JQuery or not.
      def inject_jquery=(value)
        @@inject_jquery = value
      end

      # Returns the console_password.
      #
      # @return [String] the console password.
      def console_password
        @@console_password
      end

      # Sets the console password.
      #
      # @param [String] value representing console password.
      def console_password=(value)
        @@console_password = value
      end
    end

    # Honor the Rack contract by saving the passed Rack application in an ivar.
    #
    # @param [Rack::Application] app the previous Rack application in the
    #   middleware chain.
    def initialize(app)
      @app = app
    end

    # Decides where to send the request. In case the path is `/webconsole`
    # (e.g. when calling the {Repl} endpoint), pass the request onto the
    # {Repl}. Otherwise, pass it onto the {Assets} middleware, which will
    # inject the needed assets for the Webconsole to work.
    #
    # @param [Hash] env a Rack request environment.
    def call(env)
      if env['PATH_INFO'] == '/webconsole'
        Repl.new(@app).call(env)
      else
        Assets.new(@app).call(env)
      end
    end
  end
end
