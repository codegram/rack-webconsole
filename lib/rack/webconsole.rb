# encoding: utf-8
require 'rack/webconsole/repl'
require 'rack/webconsole/asset_helpers'
require 'rack/webconsole/assets'
require 'rack/webconsole/sandbox'

require 'rack/webconsole/railtie' if defined?(Rails)

# Rack is a modular webserver interface written by Christian Neukirchen.
#
#   http://github.com/rack/rack
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
