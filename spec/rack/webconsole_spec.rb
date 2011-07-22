require 'spec_helper'

module Rack
  describe Webconsole do

    it 'initializes with an app' do
      @app = stub
      @webconsole = Webconsole.new(@app)

      @webconsole.instance_variable_get(:@app).must_equal @app
    end

    describe "#call" do
      it 'delegates the call to the Repl middleware when the path is /webconsole' do
        @app = stub
        @webconsole = Webconsole.new(@app)
        @env = {'PATH_INFO' => '/webconsole'}

        repl = stub
        Webconsole::Repl.expects(:new).with(@app).returns repl
        repl.expects(:call).with @env

        @webconsole.call(@env)
      end

      it 'passes the call to the Assets middleware otherwise' do
        @app = stub
        @webconsole = Webconsole.new(@app)
        @env = {'PATH_INFO' => '/whatever'}

        assets = stub
        Webconsole::Assets.expects(:new).with(@app).returns assets
        assets.expects(:call).with @env

        @webconsole.call(@env)
      end
    end

  end
end
