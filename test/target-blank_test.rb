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



    should 'add target attribute to text link' do
      @target_blank.instance_variable_set(:@site, @site)
      @target_blank.send(:link, @page)
      assert_equal @external_link, @page.content
    end

    should 'add target attribute to multiple text links' do
      @page.instance_variable_set(:@content, '<div>https://google.com Second link is https://www.keith-mifsud.me and other text.</div>')
      @site.pages << @page
      @target_blank.instance_variable_set(:@site, @site)
      @target_blank.send(:link, @page)
      expected = '<div><a href="https://google.com" target="_blank">https://google.com</a> Second link is <a href="https://www.keith-mifsud.me" target="_blank">https://www.keith-mifsud.me</a> and other text.</div>'
      assert_equal expected, @page.content
    end

    should 'add target attribute to anchor tag' do
      @page.instance_variable_set(:@content, '<div><a href="https://google.com">https://google.com</a></div>')
      @site.pages << @page
      @target_blank.instance_variable_set(:@site, @site)
      @target_blank.send(:process_anchor_tags, @page)
      assert_equal @external_link, @page.content
    end

    should 'add target attribute to html with multiple anchor tags' do
      @page.instance_variable_set(:@content, '<a href="https://google.com">https://google.com</a> Second link: <a href="https://www.keith-mifsud.me">https://www.keith-mifsud.me</a> and other text.')
      @site.pages << @page
      @target_blank.instance_variable_set(:@site, @site)
      @target_blank.send(:process_anchor_tags, @page)
      expected = '<a href="https://google.com" target="_blank">https://google.com</a> Second link: <a href="https://www.keith-mifsud.me" target="_blank">https://www.keith-mifsud.me</a> and other text.'
      assert_equal expected, @page.content
    end



    # should 'add target blank attribute to markdown link' do
    #   @page.instance_variable_set(:@content, '<div>[Google](https://google.com)</div>')
    #   @site.pages << @page
    #   @target_blank.instance_variable_set(:@site, @site)
    #   @target_blank.send(:link, @page)
    #   assert_equal @external_link, @page.content
    # end


    # relative links

    # internal links
    #
    # code blocks
    #
    # # all mixed
  end
end
