# frozen_string_literal: true

RSpec.describe(Jekyll::TargetBlank) do
  Jekyll.logger.log_level = :error

  let(:config_overrides) { {} }
  let(:configs) do
    Jekyll.configuration(config_overrides.merge({
      "skip_config_files" => false,
      "collections"       => { "docs" => { "output" => true } },
      "source"            => fixtures_dir,
      "destination"       => fixtures_dir("_site"),
    }))
  end
  let(:target_blank) { described_class }
  let(:site) { Jekyll::Site.new(configs) }
  let(:posts) { site.posts.docs.sort.reverse }

  # get some fixtures
  let(:post_with_external_markdown_link) { find_by_title(posts, "Post with external markdown link") }

  let(:post_with_multiple_external_markdown_links) { find_by_title(posts, "Post with multiple external markdown links") }

  let(:post_with_relative_markdown_link) { find_by_title(posts, "Post with relative markdown link") }

  let(:post_with_absolute_internal_markdown_link) { find_by_title(posts, "Post with absolute internal markdown link") }

  let(:post_with_html_anchor_tag) { find_by_title(posts, "Post with html anchor tag") }

  let(:post_with_plain_text_link) { find_by_title(posts, "Post with plain text link") }

  let(:document_with_a_processable_link) { find_by_title(site.collections["docs"].docs, "Document with a processable link") }

  let(:text_file) { find_by_title(site.collections["docs"].docs, "Text file") }
0
  let(:post_with_code_block) { find_by_title(posts, "Post with code block") }
  let(:document_with_liquid_tag) { find_by_title(site.collections["docs"].docs, "Document with liquid tag") }

  let(:document_with_include) { find_by_title(site.collections["docs"].docs, "Document with include") }

  let(:post_with_mailto_link) { find_by_title(posts, "Post with mailto link") }

  # define common wrappers.
  def para(content)
    "<p>#{content}</p>"
  end

  before(:each) do
    site.reset
    site.read
    (site.pages | posts | site.docs_to_write).each { |p| p.content.strip! }
    site.render
  end

  it "should add target attribute to external markdown link" do
    expect(post_with_external_markdown_link.output).to include(para('Link to <a href="https://google.com" target="_blank">Google</a>.'))
  end

  it "should add target attribute to multiple external markdown links" do
    expect(post_with_multiple_external_markdown_links.output).to include('<p>This post contains three links. The first link is to <a href="https://google.com" target="_blank">Google</a>, the second link is, well, to <a href="https://keithmifsud.github.io" target="_blank">my website</a> and since <a href="https://github.com" target="_blank">GitHub</a> is so awesome, why not link to them too?</p>')
  end

  it "should not add target attribute to relative markdown link" do
    expect(post_with_relative_markdown_link.output).to include(para('Link to <a href="/contact">contact page</a>.'))

    expect(post_with_relative_markdown_link.output).to_not include(para('Link to <a href="/contact" target="_blank">contact page</a>'))
  end

  it "should not add target attribute to absolute internal link" do
    expect(post_with_absolute_internal_markdown_link.output).to include('<p>This is an absolute internal <a href="https://keith-mifsud.me/contact">link</a>.</p>
')
  end

  it "should correctly handle existing html anchor tag" do
    expect(post_with_html_anchor_tag.output).to include('<p>This is an <a href="https://google.com" target="_blank">anchor tag</a>.</p>
')
  end

  it "should not interfere with plain text link" do
    expect(post_with_plain_text_link.output).to include("<p>This is a plain text link to https://google.com.</p>
")
  end

  it "should process external links in collections" do
    expect(document_with_a_processable_link.output).to include('<p>This is a valid <a href="https://google.com" target="_blank">link</a>.</p>
')
  end

  it "should process external links in pages" do
    expect(site.pages.first.output).to include('<p>This is a valid <a href="https://google.com" target="_blank">link</a>.</p>')
  end

  it "should not process links in non html files" do
    expect(text_file.output).to eq("Valid [link](https://google.com).")
  end

  it "should not process link in code block but process link outside of block" do
    expect(post_with_code_block.output).to include("<span class=\"s1\">'https://google.com'</span>")

    expect(post_with_code_block.output).not_to include("<span class=\"s1\"><a href=\"https://google.com\" target=\"_blank\">https://google.com</a></span>")

    expect(post_with_code_block.output).to include('<p>Valid <a href="https://google.com" target="_blank">link</a></p>
')
  end

  it "should not break layouts" do
    expect(site.pages.first.output).to include('<html lang="en-US">')
    expect(site.pages.first.output).to include('<body class="wrap">')
  end

  it "should not interfere with liquid tags" do
    expect(document_with_liquid_tag.output).to include('<p>This <a href="/docs/document-with-liquid-tag.html">_docs/document-with-liquid-tag.md</a> is a document with a liquid tag.</p>')
  end

  it "should not interfere with includes" do
    expect(document_with_include.output).to include("<p>This is a document with an include: This is an include.</p>")
  end

  it "should not break layout content" do
    expect(site.pages.first.output).to include("<div>Layout content started.</div>")

    expect(site.pages.first.output).to include("<div>Layout content ended.</div>")
  end

  it "should not duplicate post content" do
    expect(post_with_external_markdown_link.output).to eq(post_with_layout_result)
  end

  it "should ignore mailto links" do
    expect(post_with_mailto_link.output).to include(para('This is a <a href="mailto:mifsud.k@gmail.com?Subject=Just%20an%20email">mailto link</a>.'))
  end

  private

  def post_with_layout_result
    <<-RESULT
<!DOCTYPE HTML>
<html lang="en-US">
<head>
    <meta charset="UTF-8">
    <title>Post with external markdown link</title>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <link rel="stylesheet" href="/css/screen.css">
</head>
<body class="wrap">
    <div>Layout content started.</div>
<p>Link to <a href="https://google.com" target="_blank">Google</a>.</p>

    <div>Layout content ended.</div>
</body>
</html>
    RESULT
  end

  context "With a specified css class name" do
    let(:target_blank_css_class) { "ext-link" }
    let(:config_overrides) do
      {
        "target-blank" => { "css_class" => :target_blank_css_class }
      }
    end

    it "knows when a css class name is specified in config" do
      expect(target_blank.send :css_class_name_specified?, config_overrides).to eql(true)

      expect(target_blank.send :css_class_name_specified?, {}).to eql(false)

      expect(target_blank.send :css_class_name_specified?, {"randon_option" => "randon-value"}).to eql(false)
    end
    

=begin
    it "should not automatically add target attribute to external markdown link" do
      expect(post_with_external_markdown_link.output).to_not include(para('Link to <a href="https://google.com" target="_blank">Google</a>.'))
    end
=end
  end
end
