# frozen_string_literal: true

require "jekyll"
require "nokogiri"
require "uri"

module Jekyll
  class TargetBlank
    BODY_START_TAG         = "<body"
    OPENING_BODY_TAG_REGEX = %r!<body(.*)>\s*!

    class << self
      # Public: Processes the content and updated the external links
      # by adding target="_blank" and rel="noopener noreferrer" attributes.
      #
      # content - the document or page to be processes.
      def process(content)
        @site_url = content.site.config["url"]
        @config   = content.site.config

        return unless content.output.include?("<a")

        content.output = if content.output.include? BODY_START_TAG
                           process_html(content)
                         else
                           process_anchor_tags(content.output)
                         end
      end

      # Public: Determines if the document should be processed.
      #
      # doc - the document being processed.
      def document_processable?(doc)
        (doc.is_a?(Jekyll::Page) || doc.write?) &&
            doc.output_ext == ".html" || (doc.permalink&.end_with?("/"))
      end

      private

      # Private: Processes html content which has a body opening tag.
      #1
      # content - html to be processes.
      def process_html(content)
        head, opener, tail  = content.output.partition(OPENING_BODY_TAG_REGEX)
        body_content, *rest = tail.partition("</body>")

        processed_markup = process_anchor_tags(body_content)

        content.output = String.new(head) << opener << processed_markup << rest.join
      end

      # Private: Processes the anchor tags and adds the target
      # attribute if the link is external and depending on the config settings.
      #
      # html = the html which includes the anchor tags.
      def process_anchor_tags(html)
        content = Nokogiri::HTML::DocumentFragment.parse(html)
        anchors = content.css("a[href]")
        anchors.each do |item|
          if css_class_name_specified_in_config?
            if not_mailto_link?(item["href"]) && external?(item["href"])
              if includes_specified_css_class?(item)
                add_target_blank_attribute(item)
              end
            end
          elsif not_mailto_link?(item["href"]) && external?(item["href"])
            add_target_blank_attribute(item)
            add_default_rel_attributes(item)
            if should_add_css_classes?
              existing_classes = get_existing_css_classes(item)
              existing_classes = " " + existing_classes unless existing_classes.to_s.empty?
              item["class"] = css_classes_to_add_from_config.to_s + existing_classes
            end
          end
        end
        content.to_html
      end

      # Private: Determines of the link should be processed.  
      #
      # link = Nokogiri node.
      def processable_link(link)
        false unless not_mailto_link?(link) && external?(link)
        if css_class_name_specified_in_config?(link)
          true unless includes_specified_css_class?(link)
        end
      end

      # Private: Adds a target="_blank" to the link.
      #
      # link = Nokogiri node.
      def add_target_blank_attribute(link)
        link["target"] = "_blank"
      end

      # Private: Adds the default rel attribute and values to the link.
      #
      # link = Nokogiri node.
      def add_default_rel_attributes(link)
        link["rel"] = "noopener noreferrer"
      end

      # Private: Checks if the link is a mailto url.
      #
      # link - a url.
      def not_mailto_link?(link)
        true unless link.to_s.start_with?("mailto:")
      end

      # Private: Checks if the links points to a host
      # other than that set in Jekyll's configuration.
      #
      # link - a url.
      def external?(link)
        if link =~ URI.regexp(%w(http https))
          URI.parse(link).host != URI.parse(@site_url).host
        end
      end

      # Private: Checks if a css class name is specified in config
      def css_class_name_specified_in_config?
        target_blank_config = @config["target-blank"]
        case target_blank_config
        when nil, NilClass
          false
        else
          target_blank_config.fetch("css_class", false)
        end
      end

      # Private: Checks if the link contains the same css class name
      # as specified in config.
      #
      # link - the url under test.
      def includes_specified_css_class?(link)
        link_classes = get_existing_css_classes(link)
        if link_classes
          link_classes = link_classes.split(" ")
          contained    = false
          link_classes.each do |name|
            contained = true unless name != specified_class_name_from_config
          end
          return contained
        end
        false
      end

      # Private: Gets the the css classes of the link.
      #
      # link - an anchor tag.
      def get_existing_css_classes(link)
        link["class"].to_s
      end

      # Private: Checks if the link contains the class attribute.
      #
      # link - an anchor tag.
      def link_has_class_attribute?(link)
        link.include?("class=")
      end

      # Private: Fetches the specified css class name
      # from config.
      def specified_class_name_from_config
        target_blank_config = @config["target-blank"]
        target_blank_config.fetch("css_class")
      end

      def should_add_css_classes?
        config = @config["target-blank"]
        case config
        when nil, NilClass
          false
        else
          config.fetch("add_css_classes", false)
        end
      end

      def css_classes_to_add_from_config
        config = @config["target-blank"]
        config.fetch("add_css_classes")
      end
    end
  end
end

# Hooks into Jekyll's post_render event.
Jekyll::Hooks.register %i[pages documents], :post_render do |doc|
  Jekyll::TargetBlank.process(doc) if Jekyll::TargetBlank.document_processable?(doc)
end
