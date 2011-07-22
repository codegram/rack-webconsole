# encoding: utf-8
require 'json'

module Rack
  class Webconsole

    class Repl
      def initialize(app)
        @app = app
      end

      def call(env)
        status, headers, response = @app.call(env)

        req = Rack::Request.new(env)

        params = req.params

        result = begin
          $sandbox ||= Sandbox.new

          boilerplate = local_variables + [:ls]

          result = $sandbox.instance_eval """
            result = (#{params['query']})
            ls = (local_variables - #{boilerplate})
            @locals ||= {}
            @locals.update(ls.inject({}) do |hash, value|
              hash.update({value => eval(value.to_s)})
            end)
            result
          """

          result.inspect
        rescue=>e
          "Error: " + e.message
        end
        response_body = {:result => result}.to_json
        headers = {}
        headers['Content-Type'] = 'application/json'
        headers['Content-Length'] = response_body.length.to_s
        [200, headers, [response_body]]
      end
    end

  end
end
