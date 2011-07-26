require 'spec_helper'

class AssetClass
  include Rack::Webconsole::AssetHelpers
end

module Rack
  describe Webconsole::AssetHelpers do

    describe '#html_code' do
      it 'loads the html code' do
        asset_class = AssetClass.new
        html = asset_class.html_code

        html.must_match /console/
        html.must_match /results/
        html.must_match /form/
      end
    end

    describe '#css_code' do
      it 'loads the css code' do
        asset_class = AssetClass.new
        css = asset_class.css_code

        css.must_match /<style/
        css.must_match /text\/css/
        css.must_match /#console/
      end
    end

    describe '#js_code' do
      it 'loads the js code' do
        asset_class = AssetClass.new
        js = asset_class.js_code

        js.must_match /\$\("#rack-webconsole"\)/
        js.must_match /escapeHTML/
      end
    end

  end
end
