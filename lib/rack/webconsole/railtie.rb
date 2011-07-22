module Rack
  class Webconsole
    class Railtie < Rails::Railtie

      initializer 'rack-webconsole.add_middleware' do |app|
        app.middleware.use Rack::Webconsole
      end

    end
  end
end
