# encoding: utf-8
module Rack
  class Webconsole
    # Railtie loaded in Rails applications. Its purpose is to automatically use
    # the middleware in development environment, so that Rails users only have
    # to require 'rack-webconsole' in their Gemfile and nothing more than that.
    #
    class Railtie < Rails::Railtie
      initializer 'rack-webconsole.add_middleware' do |app|
        app.middleware.use Rack::Webconsole if Rails.env.development?
      end
    end
  end
end
