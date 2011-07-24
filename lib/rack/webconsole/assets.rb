# encoding: utf-8
module Rack
  class Webconsole
    class Assets
      include Webconsole::AssetHelpers

      def initialize(app)
        @app = app
      end

      def call(env)
        status, headers, response = @app.call(env)
        return [status, headers, response] unless check_html?(headers, response) && status == 200

        if response.respond_to?(:body)
          response_body = response.body
        else
          response_body = response.first
        end

        # Inject the html, css and js code to the view
        response_body.gsub!('</body>', "#{code}</body>")
        headers['Content-Length'] = (response_body.length + 2).to_s

        [status, headers, [response_body]]
      end

      def code
        html_code << css_code << js_code
      end

      private

      def check_html?(headers, response)
        body = response.respond_to?(:body) ? response.body : response.first
        headers['Content-Type'] and
          headers['Content-Type'].include? 'text/html' and
          body =~ %r{<html.*</html>}m
      end
    end
  end
end
