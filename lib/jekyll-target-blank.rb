require 'jekyll'
#require 'rinku'
require 'nokogiri'
require 'uri'

module Jekyll
  class TargetBlank

    BODY_START_TAG = "<body"

    OPENING_BODY_TAG_REGEX = %r!<body(.*)>\s*!
    class << self

      def process(content)
        @site_url = content.site.config['url']

        return unless content.output.include?("<a")
        if content.output.include? BODY_START_TAG
          head, opener, tail = content.output.partition(OPENING_BODY_TAG_REGEX)
          body_content, *rest = tail.partition("</body>")

          processed_markup = process_anchor_tags(content)
          content.output = String.new(head) << opener << body_content << processed_markup << rest.join

        else
          content.output = process_anchor_tags(content)
        end
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
        content.to_html
      end

      def external?(link)
        if link =~ /\A#{URI.regexp(['http', 'https'])}\z/
          URI.parse(link).host != URI.parse(@site_url).host
        end
      end
    end
  end
end

Jekyll::Hooks.register %i[pages documents], :post_render do |doc|
  Jekyll::TargetBlank.process(doc) if Jekyll::TargetBlank.processable?(doc)
end