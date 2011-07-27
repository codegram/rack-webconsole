# encoding: utf-8
module Rack
  class Webconsole
    # Helper module to encapsulate the asset loading logic used by the {Assets}
    # middleware.
    #
    # For now, the strategy is reading the files from disk. In the future, we
    # should come up with a somewhat more sophisticated strategy, although
    # {Webconsole} is used only in development environments, where performance
    # isn't usually a concern.
    #
    module AssetHelpers
      # Loads the HTML from a file in `/public`.
      #
      # It contains a form and the needed divs to render the console.
      #
      # @return [String] the injectable HTML.
      def html_code
        out = ""
        out << asset('jquery.html') if Webconsole.inject_jquery
        out << asset('webconsole.html')
        out
      end

      # Loads the CSS from a file in `/public`.
      #
      # It contains the styles for the console.
      #
      # @return [String] the injectable CSS.
      def css_code
        '<style type="text/css">' <<
          asset('webconsole.css') <<
          '</style>'
      end

      # Loads the JavaScript from a file in `/public`.
      #
      # It contains the JavaScript logic of the webconsole.
      #
      # @return [String] the injectable JavaScript.
      def js_code
        '<script type="text/javascript">' <<
          asset('webconsole.js') <<
          '</script>'
      end

      private

      def asset(file)
        @assets ||= {}
        output = ::File.open(::File.join(::File.dirname(__FILE__), '..', '..', '..', 'public', file), 'r:UTF-8') do |f|
          f.read
        end
        @assets[file] ||= output
      end
    end
  end
end
