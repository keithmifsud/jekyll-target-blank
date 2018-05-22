require 'helper'

class Jekyll::TargetBlankTest < Minitest::Test
  context 'TargetBlank' do

    setup do
      @site = Jekyll::Site.new(Jekyll::Configuration::DEFAULTS.dup)
      @target_blank = Jekyll::TargetBlank.new(@site.config)
      @page = Jekyll::Page.new(@site, File.expand_path('../../', __FILE__), '', 'README.md')
      @page.instance_variable_set(:@content, '<div>https://google.com</div>')
      @site.pages << @page
      @external_link = '<div><a href="https://google.com" target="_blank">https://google.com</a></div>'
    end

    should 'adds target blank attribute to link' do
      @target_blank.instance_variable_set(:@site, @site)
      @target_blank.send(:link, @page)
      assert_equal @external_link, @page.content
    end

  end
end
