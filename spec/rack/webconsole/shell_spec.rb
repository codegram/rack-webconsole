require 'spec_helper'

module Rack
  describe Webconsole::Shell do
    before do
      Ripl.instance_variable_set(:@shell, nil)
    end

    describe ".eval_query" do
      describe "sets Ripl::Shell" do
        before { Webconsole::Shell.eval_query('2 + 2') }

        it "#input" do
          Ripl.shell.input.must_equal '2 + 2'
        end

        it "#result" do
          Ripl.shell.result.must_equal 4
        end

        it "#history" do
          Ripl.shell.history.must_equal ['2 + 2']
        end
      end

      describe "for one line input" do
        def response
          Webconsole::Shell.eval_query("'input'")
        end

        it ":result returns inspected result" do
          response[:result].must_equal '"input"'
        end

        it ":prompt returns normal prompt" do
          response[:prompt] = '>> '
        end

        it "returns false for multi_line keys" do
          response[:multi_line].must_equal false
          response[:previous_multi_line].must_equal false
        end

        it "with an error :result returns error raised" do
          Webconsole::Shell.eval_query("blah")[:result].must_match /^Error:/
        end
      end

      describe "for multi line input" do
        def response
          [
            Webconsole::Shell.eval_query("[1,2,3].map do |num|"),
            Webconsole::Shell.eval_query("num ** 2"),
            Webconsole::Shell.eval_query("end")
          ]
        end

        it "returns correct results" do
          response.map {|e| e[:result] }.must_equal [nil, nil, "[1, 4, 9]"]
        end

        it "returns correct prompts" do
          response.map {|e| e[:prompt] }.must_equal ['>> ', '|| ', '|| ']
        end

        it "returns correct multi_line keys" do
          response.map {|e| e[:multi_line] }.must_equal [true, true, false]
          response.map {|e| e[:previous_multi_line] }.must_equal [false, true, true]
        end
      end
    end
  end
end
