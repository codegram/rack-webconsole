module Rack
  class Webconsole
    module AssetHelpers

      def html_code
        asset 'webconsole.html'
      end

      def css_code
        '<style type="text/css">' <<
          asset('webconsole.css') <<
          '</style>'
      end

      def js_code
        '<script type="text/javascript">' <<
          asset('webconsole.js') <<
          '</script>'
      end

      private

      def asset(file)
        ::File.read(::File.join(::File.dirname(__FILE__), '..', '..', '..', 'public', file))
      end

    end
  end
end

