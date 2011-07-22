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

        if status == 200 &&
          response.respond_to?(:body) &&
          !response.body.frozen? &&
          check_html?(headers, response) then

          # Inject the html, css and js code to the view
          if response.body.respond_to?(:each)
            response_body = response.body.first
          else
            response_body = response.body
          end

          response_body.gsub!('</body>', "#{code}</body>")
          headers['Content-Length'] = response_body.length.to_s
        end

        response_body ||= response.body

        [status, headers, [response_body]]
      end

      def code
        html_code << css_code << js_code
      end

      private

      def check_html?(headers, response)
        headers['Content-Type'] and
          headers['Content-Type'].include? 'text/html' and
          response.body =~ %r{<html.*</html>}m
      end
    end
  end
end
