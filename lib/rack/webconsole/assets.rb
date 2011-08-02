# encoding: utf-8
module Rack
  class Webconsole
    # {Assets} is a Rack middleware responsible for injecting view code for the
    # console to work properly.
    #
    # It intercepts HTTP requests, detects successful HTML responses and
    # injects HTML, CSS and JavaScript code into those.
    #
    class Assets
      include Webconsole::AssetHelpers

      # Honor the Rack contract by saving the passed Rack application in an ivar.
      #
      # @param [Rack::Application] app the previous Rack application in the
      #   middleware chain.
      def initialize(app)
        @app = app
      end

      # Checks for successful HTML responses and injects HTML, CSS and
      # JavaScript code into them.
      #
      # @param [Hash] env a Rack request environment.
      def call(env)
        status, headers, response = @app.call(env)
        return [status, headers, response] unless check_html?(headers, response) && status == 200

        if response.respond_to?(:body)
          response_body = response.body
        else
          response_body = response.first
        end

        # Regenerate the security token
        Webconsole::Repl.reset_token

        # Expose the request object to the Repl
        Webconsole::Repl.request = Rack::Request.new(env)

        # Inject the html, css and js code to the view
        response_body.gsub!('</body>', "#{code}</body>")

        headers['Content-Length'] = response_body.bytesize.to_s

        [status, headers, [response_body]]
      end

      # Returns a string with all the HTML, CSS and JavaScript code needed for
      # the view.
      #
      # It puts the security token inside the JavaScript to make AJAX calls
      # secure.
      #
      # @return [String] the injectable code.
      def code
        html_code <<
          css_code <<
          render(js_code, :TOKEN => Webconsole::Repl.token, :KEY_CODE => Webconsole.key_code)
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
