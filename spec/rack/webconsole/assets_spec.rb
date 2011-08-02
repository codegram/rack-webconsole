# encoding: utf-8
require 'spec_helper'
require 'ostruct'

module Rack
  describe Webconsole::Assets do

    it 'initializes with an app' do
      @app = stub
      @assets = Webconsole::Assets.new(@app)
      @assets.instance_variable_get(:@app).must_equal @app
    end

    describe "#code" do
      it 'injects the token and key_code' do
        Webconsole::Repl.stubs(:token).returns('fake_generated_token')
        Webconsole.key_code = "96"

        @assets = Webconsole::Assets.new(nil)
        assets_code = @assets.code

        assets_code.must_match /fake_generated_token/
        assets_code.must_match /event\.which == 96/
      end
    end

    describe "#call" do

      describe 'when the call is not appropriate to inject the view code' do
        # Different invalid cases
        [
          [200, {'Content-Type' => 'text/html'}, ['Whatever']],
          [200, {'Content-Type' => 'text/plain'}, ['Hello World']],
          [404, {'Content-Type' => 'text/html'}, ['Hello World']],
          [404, {'Content-Type' => 'text/html'}, ['Hello, World']],

        ].each do |invalid_response|
          it 'passes the call untouched' do
            @app = lambda { |env| invalid_response }

            assets = Webconsole::Assets.new(@app)
            assets.expects(:inject_code).never

            assets.call({}).last.first.must_equal invalid_response.last.first
          end
        end
      end

      describe 'otherwise' do

        it 'injects the view code before the body ending' do

          valid_html = "<!DOCTYPE html>\n<html>\n<head>\n  <title>Testapp</title>\n  <link href=\"/assets/application.css\" media=\"screen\" rel=\"stylesheet\" type=\"text/css\" />\n  <script src=\"/assets/application.js\" type=\"text/javascript\"></script>\n  <meta content=\"authenticity_token\" name=\"csrf-param\" />\n<meta content=\"26Ls63zdKBiCXoqU5CuG6KqVbeMYydRqOuovP+DXx8g=\" name=\"csrf-token\" />\n</head>\n<body>\n\n<h1> Hello bitches </h1>\n\n<p> Lorem ipsum dolor sit amet. </p>\n\n\n</body>\n</html>\n"

          html = [valid_html]

          @app = lambda { |env| [200, {'Content-Type' => 'text/html'}, html] }

          assets = Webconsole::Assets.new(@app)
          response = assets.call({}).last.first

          response.must_match /input name/m # html
          response.must_match /text\/css/m # css
          response.must_match /escapeHTML/m # js
        end

        it "works with Rails' particular conception of what a response is" do

          valid_html = "<!DOCTYPE html>\n<html>\n<head>\n  <title>Testapp</title>\n  <link href=\"/assets/application.css\" media=\"screen\" rel=\"stylesheet\" type=\"text/css\" />\n  <script src=\"/assets/application.js\" type=\"text/javascript\"></script>\n  <meta content=\"authenticity_token\" name=\"csrf-param\" />\n<meta content=\"26Ls63zdKBiCXoqU5CuG6KqVbeMYydRqOuovP+DXx8g=\" name=\"csrf-token\" />\n</head>\n<body>\n\n<h1> Hello bitches </h1>\n\n<p> Lorem ipsum dolor sit amet. </p>\n\n\n</body>\n</html>\n"

          @app = lambda { |env| [200, {'Content-Type' => 'text/html'}, OpenStruct.new({:body => valid_html})] }

          assets = Webconsole::Assets.new(@app)

          response = assets.call({}).last.first

          response.must_match /input name/m # html
          response.must_match /text\/css/m # css
          response.must_match /escapeHTML/m # js
        end

        it 'exposes the request object to the console' do
          valid_html = "<!DOCTYPE html>\n<html>\n<head>\n  <title>Testapp</title>\n  <link href=\"/assets/application.css\" media=\"screen\" rel=\"stylesheet\" type=\"text/css\" />\n  <script src=\"/assets/application.js\" type=\"text/javascript\"></script>\n  <meta content=\"authenticity_token\" name=\"csrf-param\" />\n<meta content=\"26Ls63zdKBiCXoqU5CuG6KqVbeMYydRqOuovP+DXx8g=\" name=\"csrf-token\" />\n</head>\n<body>\n\n<h1> Hello bitches </h1>\n\n<p> Lorem ipsum dolor sit amet. </p>\n\n\n</body>\n</html>\n"

          @app = lambda { |env| [200, {'Content-Type' => 'text/html'}, OpenStruct.new({:body => valid_html})] }

          env = {'PATH_INFO' => '/some_path'}
          assets = Webconsole::Assets.new(@app)

          assets.call(env)

          Webconsole::Repl.request.env['PATH_INFO'].must_equal '/some_path'
        end

      end
    end

  end
end
