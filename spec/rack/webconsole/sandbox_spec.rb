require 'spec_helper'

module Rack
  describe Webconsole::Sandbox do

    describe "#method_missing" do
      describe 'when the method exists in @locals' do
        it 'retrieves it' do
          @sandbox = Webconsole::Sandbox.new
          @sandbox.instance_variable_set(:@locals, {:a => 123})

          @sandbox.a.must_equal 123
        end
      end
      describe 'otherwise' do
        it 'raises a NoMethodError' do
          @sandbox = Webconsole::Sandbox.new

          lambda {
            @sandbox.a
          }.must_raise NoMethodError
        end
      end
    end

    describe "#reload!" do
      it 'assigns a new, fresh Sandbox to the global variable' do
        old_sandbox = $sandbox = Webconsole::Sandbox.new

        $sandbox.reload!

        $sandbox.wont_equal old_sandbox
      end
      it 'returns a feedback string' do
        Webconsole::Sandbox.new.reload!.must_equal 'ok'
      end
    end

    describe "request" do
      it 'returns the request object' do
        @sandbox = Webconsole::Sandbox.new
        request = Rack::Request.new({'PATH_INFO' => '/some_path'})
        Webconsole::Repl.request = request

        @sandbox.request.must_equal request
      end
    end

  end
end
