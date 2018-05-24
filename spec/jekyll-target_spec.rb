# frozen_string_literal: true

RSpec.describe(Jekyll::TargetBlank) do
  Jekyll.logger.log_level = :error

  let(:config_overrides) {{}}
  let(:configs) do
    Jekyll.configuration(config_overrides.merge({
      "skip_config_files" => false,
      "collections" => {"docs" => {"output" => true}},
      "source" => fixtures_dir,
      "destination" => fixtures_dir("_site"),
    }))
  end
  let(:target_blank) { described_class }
  let(:site) { Jekyll::Site.new(configs) }
  let(:posts) { site.posts.docs.sort.reverse }

  # get some fixtures
  let(:post_with_external_markdown_link) { find_by_title(posts, 'Post with external markdown link') }

  let(:post_with_multiple_external_markdown_links) { find_by_title(posts, 'Post with multiple external markdown links') }

  let(:post_with_internal_markdown_link) { find_by_title(posts, 'Post with internal markdown link') }

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

  it 'should add target attribute to external markdown link' do
    expect(post_with_external_markdown_link.output).to start_with(para('Link to <a href="https://google.com" target="_blank">Google</a>.'))
  end

  it 'should add target attribute to multiple external markdown links' do
    expect(post_with_multiple_external_markdown_links.output).to eq('<p>This post contains three links. The first link is to <a href="https://google.com" target="_blank">Google</a>, the second link is, well, to <a href="https://keithmifsud.github.io" target="_blank">my website</a> and since <a href="https://github.com" target="_blank">GitHub</a> is so awesome, why not link to them too?</p>
'
)
  end

  it 'should not add target attribute to internal markdown link' do
    expect(post_with_internal_markdown_link.output).to start_with(para('Link to <a href="/contact">contact page</a>.'))
  end



  # should NOT add target attribute to internal markdown links
  #
  # should NOT add target attribute to relative markdown links

  # should NOT interfere with html links
  # should NOT interfere with text links.
  # should work the same with collections / docs.
  # mix with internal and external
  #
  # remove rinku if no longer needed.


end