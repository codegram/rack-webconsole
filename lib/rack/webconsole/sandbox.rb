# encoding: utf-8
module Rack
  class Webconsole

    class Sandbox
      def method_missing(m, *a, &b)
        @locals ||= {}
        @locals[m] || super
      end

      def reload!
        $sandbox = Sandbox.new
        'ok'
      end
    end

  end
end
