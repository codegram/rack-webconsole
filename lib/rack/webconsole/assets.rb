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

        response_body = full_body(response)

        # Regenerate the security token
        Webconsole::Repl.reset_token

        # Expose the request object to the Repl
        Webconsole::Repl.request = Rack::Request.new(env)

        # Inject the html, css and js code to the view
        response_body.gsub!('</body>', "#{code(env)}</body>")

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
      def code(env)
        html_code <<
          css_code <<
          render(js_code,
                 :TOKEN => Webconsole::Repl.token,
                 :KEY_CODE => Webconsole.key_code,
                 :CONTEXT => env['SCRIPT_NAME'] || "")
      end

      private

      def check_html?(headers, response)
        return false unless headers['Content-Type'] && headers['Content-Type'].include?('text/html')

        full_body(response) =~ %r{<html.*</html>}m
      end

      def full_body(response)
        response_body = ""
        response.each { |part| response_body << part }
        response_body
      end
    end
  end
end
