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
        Webconsole::Repl.stubs(:token).returns('abc')
        request = OpenStruct.new(:params => {'query' => 'a = 4; a * 2', 'token' => 'abc'}, :post? => true)
        Rack::Request.stubs(:new).returns request

        @repl = Webconsole::Repl.new(@app)

        response = @repl.call(env).last.first

        MultiJson.decode(response)['result'].must_equal "8"
      end

      it 'maintains local state in subsequent calls thanks to an evil global variable' do
        @app = lambda { |env| [200, {'Content-Type' => 'text/plain'}, ['hello world']] }
        env = {}
        Webconsole::Repl.stubs(:token).returns('abc')
        request = OpenStruct.new(:params => {'query' => 'a = 4', 'token' => 'abc'}, :post? => true)
        Rack::Request.stubs(:new).returns request
        @repl = Webconsole::Repl.new(@app)

        @repl.call(env) # call 1 sets a to 4

        request = OpenStruct.new(:params => {'query' => 'a * 8', 'token' => 'abc'}, :post? => true)
        Rack::Request.stubs(:new).returns request

        response = @repl.call(env).last.first # call 2 retrieves a and multiplies it by 8

        MultiJson.decode(response)['result'].must_equal "32"
        $sandbox.instance_variable_get(:@locals)[:a].must_equal 4
        $sandbox.instance_variable_get(:@locals).size.must_equal 1
      end

      it "returns any found errors prepended with 'Error:'" do
        @app = lambda { |env| [200, {'Content-Type' => 'text/plain'}, ['hello world']] }
        env = {}
        Webconsole::Repl.stubs(:token).returns('abc')
        request = OpenStruct.new(:params => {'query' => 'unknown_method', 'token' => 'abc'}, :post? => true)
        Rack::Request.stubs(:new).returns request
        @repl = Webconsole::Repl.new(@app)

        response = @repl.call(env).last.first

        MultiJson.decode(response)['result'].must_match /Error:/
      end

      it 'rejects non-post requests' do
        @app = lambda { |env| [200, {'Content-Type' => 'text/plain'}, ['hello world']] }
        env = {}
        Webconsole::Repl.stubs(:token).returns('abc')
        request = OpenStruct.new(:params => {'query' => 'unknown_method', 'token' => 'abc'}, :post? => false)
        Rack::Request.stubs(:new).returns request
        @repl = Webconsole::Repl.new(@app)

        $sandbox.expects(:instance_eval).never

        @repl.call(env).must_equal @app.call(env)
      end

      it 'rejects requests with invalid token' do
        @app = lambda { |env| [200, {'Content-Type' => 'text/plain'}, ['hello world']] }
        env = {}
        Webconsole::Repl.stubs(:token).returns('abc')
        request = OpenStruct.new(:params => {'query' => 'unknown_method', 'token' => 'cba'}, :post? => true)
        Rack::Request.stubs(:new).returns request
        @repl = Webconsole::Repl.new(@app)

        $sandbox.expects(:instance_eval).never

        @repl.call(env).must_equal @app.call(env)
      end
    end

    describe 'class methods' do
      describe '#reset_token and #token' do
        it 'returns the security token' do
          Webconsole::Repl.reset_token
          Webconsole::Repl.token.must_be_kind_of String
        end
      end
      describe '#request= and #request' do
        it 'returns the request object' do
          request = stub
          Webconsole::Repl.request = request
          Webconsole::Repl.request.must_equal request
        end
      end
    end

  end
end
