require 'spec_helper'
require 'ostruct'

module Rack
  describe Webconsole::Repl do

    it 'initializes with an app' do
      @app = stub
      @repl = Webconsole::Repl.new(@app)

      @repl.instance_variable_get(:@app).must_equal @app
    end

    describe "#call" do
      it 'evaluates the :query param in a sandbox and returns the result' do
        @app = lambda { |env| [200, {'Content-Type' => 'text/plain'}, ['hello world']] }
        env = {}
        request = OpenStruct.new(:params => {'query' => 'a = 4; a * 2'})
        Rack::Request.stubs(:new).returns request

        @repl = Webconsole::Repl.new(@app)

        response = @repl.call(env).last.first

        JSON.parse(response)['result'].must_equal "8"
      end

      it 'maintains local state in subsequent calls thanks to an evil global variable' do
        @app = lambda { |env| [200, {'Content-Type' => 'text/plain'}, ['hello world']] }
        env = {}
        request = OpenStruct.new(:params => {'query' => 'a = 4'})
        Rack::Request.stubs(:new).returns request
        @repl = Webconsole::Repl.new(@app)

        @repl.call(env) # call 1 sets a to 4

        request = OpenStruct.new(:params => {'query' => 'a * 8'})
        Rack::Request.stubs(:new).returns request

        response = @repl.call(env).last.first # call 2 retrieves a and multiplies it by 8

        JSON.parse(response)['result'].must_equal "32"
        $sandbox.instance_variable_get(:@locals)[:a].must_equal 4
      end

      it "returns any found errors prepended with 'Error:'" do
        @app = lambda { |env| [200, {'Content-Type' => 'text/plain'}, ['hello world']] }
        env = {}
        request = OpenStruct.new(:params => {'query' => 'unknown_method'})
        Rack::Request.stubs(:new).returns request
        @repl = Webconsole::Repl.new(@app)

        response = @repl.call(env).last.first

        JSON.parse(response)['result'].must_match /Error:/
      end
    end

  end
end
