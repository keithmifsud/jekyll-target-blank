require 'jekyll'
#require 'rinku'
require 'nokogiri'
require 'uri'

module Jekyll
  class TargetBlank

    class << self

      def process(content)
        @site_url = content.site.config['url']
        process_anchor_tags(content)
      end
      
      def processable?(doc)
        (doc.is_a?(Jekyll::Page) || doc.write?) &&
          doc.output_ext == ".html" || (doc.permalink&.end_with?("/"))
      end

      private

      def process_anchor_tags(page)
        content = Nokogiri::HTML::DocumentFragment.parse(page.content)
        anchors = content.css('a[href]')
        anchors.each do |item|
          if external?(item['href'])
            item['target'] = '_blank'
          end
        end
        page.output = content.to_html
      end

      def external?(link)
        if link =~ /\A#{URI.regexp(['http', 'https'])}\z/
          URI.parse(link).host != URI.parse(@site_url).host
        end
      end

=begin
      def link_from_text(page)
        page.output = Rinku.auto_link(page.content, :urls) do |external_link|
          external_link
        end
        @page = page
      end
=end
  

  
=begin
      def process_markdown_links(page)
        @site.config['kramdown'] = @site.config['kramdown'].dup
          #converted = Jekyll::Renderer.new(@site, page, @site.site_payload).convert(page.content)
        converted = page.process
        converted.content
      end
=end
  
  
      
    end
  end
end

Jekyll::Hooks.register %i[pages documents], :post_render do |doc|
  Jekyll::TargetBlank.process(doc) if Jekyll::TargetBlank.processable?(doc)
end