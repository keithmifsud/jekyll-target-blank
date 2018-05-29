require 'jekyll'
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
          content.output = process_html(content)
        else
          content.output = process_anchor_tags(content.output)
        end
      end

      def processable?(doc)
        (doc.is_a?(Jekyll::Page) || doc.write?) &&
            doc.output_ext == ".html" || (doc.permalink&.end_with?("/"))
      end

      private

      def process_html(content)
        head, opener, tail = content.output.partition(OPENING_BODY_TAG_REGEX)
        body_content, *rest = tail.partition("</body>")

        puts "head is: \n #{head} \n opener is: #{opener} \n tail is: #{tail} \n"
        puts "content is: \n #{body_content} \n rest is: #{rest} \n"

        processed_markup = process_anchor_tags(body_content)
        content.output = String.new(head) << opener  << processed_markup << rest.join
      end

      def process_anchor_tags(html)
        content = Nokogiri::HTML::DocumentFragment.parse(html)
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