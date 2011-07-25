# encoding: utf-8
require 'json'
module Rack
  class Webconsole
    # {Repl} is a Rack middleware acting as a Ruby evaluator application.
    #
    # In a nutshell, it evaluates a string in a {Sandbox} instance stored in an
    # evil global variable. Then, to keep the state, it inspects the local
    # variables and stores them in an instance variable for further retrieval.
    #
    class Repl
      # Honor the Rack contract by saving the passed Rack application in an ivar.
      #
      # @param [Rack::Application] app the previous Rack application in the
      #   middleware chain.
      def initialize(app)
        @app = app
      end

      # Evaluates a string as Ruby code and returns the evaluated result as
      # JSON.
      #
      # It also stores the {Sandbox} state in a `$sandbox` global variable, with
      # its local variables.
      #
      # @param [Hash] env the Rack request environment.
      # @return [Array] a Rack response with status code 200, HTTP headers
      #   and the evaluated Ruby result.
      def call(env)
        status, headers, response = @app.call(env)

        req = Rack::Request.new(env)

        params = req.params

        result = begin
          $sandbox ||= Sandbox.new

          # Force conversion to symbols due to issues with lovely 1.8.7
          boilerplate = local_variables.map(&:to_sym) + [:ls]

          result = $sandbox.instance_eval """
            result = (#{params['query']})
            ls = (local_variables.map(&:to_sym) - [#{boilerplate.join(', ')}])
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
