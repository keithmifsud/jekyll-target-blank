# frozen_string_literal: true

RSpec.describe(Jekyll::TargetBlank) do
  Jekyll.logger.log_level = :error

  let(:config_overrides) {{}}
  let(:configs) do
    Jekyll.configuration(config_overrides.merge({
        "skip_config_file" => false,
        "collections" => { "docs" => { "output" => true} },
        "source" => fixtures_dir,
        "destination" => fixtures_dir("_site"),
    }))
  end

  let(:target_blank) { described_class }
  let(:site) { Jekyll::Site.new(configs) }
  let(:text_link) { "www.google.com" }
  let(:mardown_link) { "[Google](https://google.com)" }
  let(:text_link_result) { "<a href=\"http://www.google.com\" target=\"_blank\">www.google.com</a>" }
  let(:mardown_link_result) { "<a href=\"https://google.com\" target=\"_blank\">Google" }

  let(:posts) { site.posts.docs.sort.reverse }
  let(:basic_post) { find_by_title(posts, "Basic Post") }
  let(:code_block_post) { find_by_title(posts, "Code Block Post") }

  let(:basic_document) { find_by_title(site.collections["docs"].docs, "Basic document") }

  # more coming


  def paragraph(content)
    "<p>#{content}</p>"
  end

  before(:each) do
    site.reset
    site.read
    (site.pages | posts | site.docs_to_write).each {|p| p.content.strip! }
    site.render
  end

  it 'should add target attribute to link' do
    expect(basic_post.output).to start_with(paragraph(text_link_result))
  end

end