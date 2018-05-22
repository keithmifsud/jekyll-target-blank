require 'jekyll'
require 'rinku'

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
      site.pages.each { |page| link page if page.html? }
      site.posts.docs.each { |page| link page }
    end


    private

    def link(page)
      page.content = Rinku.auto_link(page.content, :urls, 'target="_blank"') do |external_link|
        external_link
      end
      #url_encode_external_links(page.content)
    end

    def url_encode_external_links(content)
      content.gsub!(/http:(#{external_links.join('|')})/) do |m|
        m[ ] = ERB::Util.url_encode( )
        m
      end
    end
  end
end