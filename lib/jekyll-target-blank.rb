require 'jekyll'
require 'rinku'
require 'nokogiri'

module Jekyll
  class TargetBlank < Jekyll::Generator

    attr_accessor :external_links

    safe true

    def initialize(config)
      config['target-blank'] ||= {}
      self.external_links = []
    end

    def generate(site)
      @site = site
      site.pages.each { |page| process page if page.html? }
      site.posts.docs.each { |page| process page }
    end

    private

    def process(page)
      link(page)
      process_anchor_tags(page)
    end

    private

    def link(page)
      page.content = Rinku.auto_link(page.content, :urls, 'target="_blank"') do |external_link|
        external_link
      end
      #url_encode_external_links(page.content)
    end

    private

    def process_anchor_tags(page)
      content = Nokogiri::HTML::DocumentFragment.parse(page.content)
      anchors = content.css('a[href]')
      anchors.each do |item|
        item['target'] = '_blank'
      end
      page.content = content.to_html
    end

    def url_encode_external_links(content)
      content.gsub!(/http:(#{external_links.join('|')})/) do |m|
        m[ ] = ERB::Util.url_encode( )
        m
      end
    end
  end
end