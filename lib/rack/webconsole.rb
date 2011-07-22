# encoding: utf-8
require 'rack/webconsole/repl'
require 'rack/webconsole/asset_helpers'
require 'rack/webconsole/assets'
require 'rack/webconsole/sandbox'

require 'rack/webconsole/railtie' if defined?(Rails)

module Rack
  class Webconsole

    def initialize(app)
      @app = app
    end

    def call(env)
      # Pass the chain onto the Repl if appropriate
      if env['PATH_INFO'] == '/webconsole'
        Repl.new(@app).call(env)
      else # if not, pass it to the assets
        Assets.new(@app).call(env)
      end
    end

  end
end
