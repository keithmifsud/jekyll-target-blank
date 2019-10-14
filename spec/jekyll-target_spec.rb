# frozen_string_literal: true

RSpec.describe(Jekyll::TargetBlank) do
  Jekyll.logger.log_level = :error

  let(:config_overrides) { {} }
  let(:config_overrides) do
    {
      'url' => 'https://keith-mifsud.me',
      'collections' => { 'docs' => { 'output' => 'true' } }
    }
  end
  let(:configs) do
    Jekyll.configuration(config_overrides.merge(
                           'skip_config_files' => false,
                           'collections' => { 'docs' => { 'output' => true } },
                           'source' => unit_fixtures_dir,
                           'destination' => unit_fixtures_dir('_site')
                         ))
  end
  let(:target_blank) { described_class }
  let(:site) { Jekyll::Site.new(configs) }
  let(:posts) { site.posts.docs.sort.reverse }

  # get some fixtures
  let(:post_with_external_markdown_link) { find_by_title(posts, 'Post with external markdown link') }

  let(:post_with_multiple_external_markdown_links) { find_by_title(posts, 'Post with multiple external markdown links') }

  let(:post_with_relative_markdown_link) { find_by_title(posts, 'Post with relative markdown link') }

  let(:post_with_absolute_internal_markdown_link) { find_by_title(posts, 'Post with absolute internal markdown link') }

  let(:post_with_html_anchor_tag) { find_by_title(posts, 'Post with html anchor tag') }

  let(:post_with_plain_text_link) { find_by_title(posts, 'Post with plain text link') }

  let(:document_with_a_processable_link) { find_by_title(site.collections['docs'].docs, 'Document with a processable link') }

  let(:text_file) { find_by_title(site.collections['docs'].docs, 'Text file') }

  let(:post_with_code_block) { find_by_title(posts, 'Post with code block') }
  let(:document_with_liquid_tag) { find_by_title(site.collections['docs'].docs, 'Document with liquid tag') }

  let(:document_with_include) { find_by_title(site.collections['docs'].docs, 'Document with include') }

  let(:post_with_mailto_link) { find_by_title(posts, 'Post with mailto link') }

  let(:post_with_external_html_link_and_random_css_classes) { find_by_title(posts, 'Post with external html link and random css classes') }

  let(:post_with_html_link_containing_the_specified_css_class) { find_by_title(posts, 'Post with html link containing the specified css class') }

  let(:post_with_external_link_containing_the_specified_css_class_and_other_css_classes) { find_by_title(posts, 'Post with external link containing the specified css class and other css classes') }

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

  context 'Without entries in config file' do
    let(:config_overrides) do
      { 'target-blank' => { 'add_css_classes' => false } }
    end

    it 'should add target attribute to external markdown link' do
      expect(post_with_external_markdown_link.output).to include(para('Link to <a href="https://google.com" target="_blank" rel="noopener noreferrer">Google</a>.'))
    end

    it 'should add target attribute to multiple external markdown links' do
      expect(post_with_multiple_external_markdown_links.output).to include('<p>This post contains three links. The first link is to <a href="https://google.com" target="_blank" rel="noopener noreferrer">Google</a>, the second link is, well, to <a href="https://keithmifsud.github.io" target="_blank" rel="noopener noreferrer">my website</a> and since <a href="https://github.com" target="_blank" rel="noopener noreferrer">GitHub</a> is so awesome, why not link to them too?</p>')
    end

    it 'should not add target attribute to relative markdown link' do
      expect(post_with_relative_markdown_link.output).to include(para('Link to <a href="/contact">contact page</a>.'))

      expect(post_with_relative_markdown_link.output).to_not include(para('Link to <a href="/contact" target="_blank" rel="noopener noreferrer">contact page</a>'))
    end

    it 'should not add target attribute to absolute internal link' do
      expect(post_with_absolute_internal_markdown_link.output).to include('<p>This is an absolute internal <a href="https://keith-mifsud.me/contact">link</a>.</p>')
    end

    it 'should correctly handle existing html anchor tag' do
      expect(post_with_html_anchor_tag.output).to include('<p>This is an <a href="https://google.com" target="_blank" rel="noopener noreferrer">anchor tag</a>.</p>')
    end

    it 'should not interfere with plain text link' do
      expect(post_with_plain_text_link.output).to include('<p>This is a plain text link to https://google.com.</p>')
    end

    it 'should process external links in collections' do
      expect(document_with_a_processable_link.output).to include('<p>This is a valid <a href="https://google.com" target="_blank" rel="noopener noreferrer">link</a>.</p>')
    end

    it 'should process external links in pages' do
      expect(site.pages.first.output).to include('<p>This is a valid <a href="https://google.com" target="_blank" rel="noopener noreferrer">link</a>.</p>')
    end

    it 'should not process links in non html files' do
      expect(text_file.output).to eq('Valid [link](https://google.com).')
    end

    it 'should not process link in code block but process link outside of block' do
      expect(post_with_code_block.output).to include('<span class="s1">\'https://google.com\'</span>')

      expect(post_with_code_block.output).not_to include('<span class="s1"><a href="https://google.com" target="_blank" rel="noopener noreferrer">https://google.com</a></span>')

      expect(post_with_code_block.output).to include('<p>Valid <a href="https://google.com" target="_blank" rel="noopener noreferrer">link</a></p>')
    end

    it 'should not break layouts' do
      expect(site.pages.first.output).to include('<html lang="en-US">')
      expect(site.pages.first.output).to include('<body class="wrap">')
    end

    it 'should not interfere with liquid tags' do
      expect(document_with_liquid_tag.output).to include('<p>This <a href="/docs/document-with-liquid-tag.html">_docs/document-with-liquid-tag.md</a> is a document with a liquid tag.</p>')
    end

    it 'should not interfere with includes' do
      expect(document_with_include.output).to include('<p>This is a document with an include: This is an include.</p>')
    end

    it 'should not break layout content' do
      expect(site.pages.first.output).to include('<div>Layout content started.</div>')

      expect(site.pages.first.output).to include('<div>Layout content ended.</div>')
    end

    it 'should not duplicate post content' do
      expect(post_with_external_markdown_link.output).to eq(post_with_layout_result)
    end

    it 'should ignore mailto links' do
      expect(post_with_mailto_link.output).to include(para('This is a <a href="mailto:mifsud.k@gmail.com?Subject=Just%20an%20email">mailto link</a>.'))
    end
  end

  context 'With a specified css class name' do
    let(:target_blank_css_class) { 'ext-link' }
    let(:config_overrides) do
      {
        'target-blank' => {
          'css_class' => target_blank_css_class,
          'add_css_classes' => false
        }
      }
    end

    it 'should not add target attribute to external markdown link that does not have the specified css class' do
      expect(post_with_external_markdown_link.output).to_not include(para('Link to <a href="https://google.com" target="_blank">Google</a>.'))
    end

    it 'should not add target attribute to external markdown link that does not have the specified css class even if it does have other css classes' do
      expect(post_with_external_html_link_and_random_css_classes.output).to include(para('<a href="https://google.com" class="random-class another-random-class">Link</a>.'))

      expect(post_with_external_html_link_and_random_css_classes.output).to_not include('target="_blank" rel="noopener noreferrer"')
    end

    it 'should add target attribute to an external link containing the specified css class' do
      expect(post_with_html_link_containing_the_specified_css_class.output).to include(para('<a href="https://google.com" class="ext-link" target="_blank" rel="noopener noreferrer">Link with the css class specified in config</a>.'))
    end

    it 'should add target attribute to an external link containing the specified css class even when other css classes are specified' do
      expect(post_with_external_link_containing_the_specified_css_class_and_other_css_classes.output).to include(para('This is <a href="https://not-keith-mifsud.me" class="random-class ext-link another-random-class" target="_blank" rel="noopener noreferrer">a link containing the specified css class and two other random css classes</a>.'))
    end
  end

  context 'Adds a CSS classes to the links' do
    let(:target_blank_add_css_class) { 'some-class' }
    let(:config_overrides) do
      { 'target-blank' => { 'add_css_classes' => target_blank_add_css_class } }
    end

    it 'should add the CSS class specified in config' do
      expect(post_with_external_markdown_link.output).to include(para('Link to <a href="https://google.com" target="_blank" rel="noopener noreferrer" class="some-class">Google</a>.'))
    end

    it 'should add the CSS class specified in config even when the link already has a CSS class specified' do
      expect(post_with_html_link_containing_the_specified_css_class.output).to include(para('<a href="https://google.com" class="some-class ext-link" target="_blank" rel="noopener noreferrer">Link with the css class specified in config</a>.'))
    end

    it 'should add the CSS class specified in config even when the link has more than CSS classes already included' do
      expect(post_with_external_link_containing_the_specified_css_class_and_other_css_classes.output).to include(para('This is <a href="https://not-keith-mifsud.me" class="some-class random-class ext-link another-random-class" target="_blank" rel="noopener noreferrer">a link containing the specified css class and two other random css classes</a>.'))
    end
  end

  context 'When more than one CSS classes are specified in config' do
    it 'should add the CSS classes specified in config' do
      expect(post_with_external_markdown_link.output).to include(para('Link to <a href="https://google.com" target="_blank" rel="noopener noreferrer" class="some-class other-some-class another-some-class">Google</a>.'))
    end

    it 'should add the CSS classes specified in config even when the link already has a CSS class included' do
      expect(post_with_html_link_containing_the_specified_css_class.output).to include(para('<a href="https://google.com" class="some-class other-some-class another-some-class ext-link" target="_blank" rel="noopener noreferrer">Link with the css class specified in config</a>.'))
    end

    it 'should add the CSS classes specified in config even when the link already has more than one CSS classes included' do
      expect(post_with_external_link_containing_the_specified_css_class_and_other_css_classes.output).to include(para('This is <a href="https://not-keith-mifsud.me" class="some-class other-some-class another-some-class random-class ext-link another-random-class" target="_blank" rel="noopener noreferrer">a link containing the specified css class and two other random css classes</a>.'))
    end
  end

  context 'When noopener is set to false in config' do
    let(:noopener) { false }
    let(:config_overrides) do
      {
        'target-blank' => {
          'add_css_classes' => false,
          'noopener' => noopener
        }
      }
    end

    it 'should not add noopener value to the rel attribute' do
      expect(post_with_external_markdown_link.output).to_not include(para('Link to <a href="https://google.com" target="_blank" rel="noopener noreferrer">Google</a>.'))
    end

    it 'should still add noreferrer value to the rel attribute' do
      expect(post_with_external_markdown_link.output).to include(para('Link to <a href="https://google.com" target="_blank" rel="noreferrer">Google</a>.'))
    end
  end

  context 'When noreferrer is set to false in config' do
    let(:noreferrer) { false }
    let(:config_overrides) do
      {
        'target-blank' => {
          'add_css_classes' => false,
          'noreferrer' => noreferrer
        }
      }
    end

    it 'should not add noreferrer value to the rel attribute' do
      expect(post_with_external_markdown_link.output).to_not include(para('Link to <a href="https://google.com" target="_blank" rel="noopener noreferrer">Google</a>.'))
    end

    it 'should still add noopener value to the rel attribute' do
      expect(post_with_external_markdown_link.output).to include(para('Link to <a href="https://google.com" target="_blank" rel="noopener">Google</a>.'))
    end
  end

  context 'When both noopener and noreferrer values are set to false in config' do
    let(:noopener) { false }
    let(:noreferrer) { false }
    let(:config_overrides) do
      {
        'target-blank' => {
          'add_css_classes' => false,
          'noopener' => noopener,
          'noreferrer' => noreferrer
        }
      }
    end

    it 'should not include the rel attribute values' do
      expect(post_with_external_markdown_link.output).to_not include(para('Link to <a href="https://google.com" target="_blank" rel="noopener noreferrer">Google</a>.'))
    end

    it 'should not include the rel attribute noopener value' do
      expect(post_with_external_markdown_link.output).to_not include(para('Link to <a href="https://google.com" target="_blank" rel="noreferrer">Google</a>.'))
    end

    it 'should not include the rel attribute noreferrer value' do
      expect(post_with_external_markdown_link.output).to_not include(para('Link to <a href="https://google.com" target="_blank" rel="noopener">Google</a>.'))
    end

    it 'should not include any rel attributes' do
      expect(post_with_external_markdown_link.output).to include(para('Link to <a href="https://google.com" target="_blank">Google</a>.'))
    end
  end

  context 'When one additional rel attribute is added in config' do
    let(:rel_attribute) { 'nofollow' }
    let(:config_overrides) do
      {
        'target-blank' => {
          'add_css_classes' => false,
          'rel' => rel_attribute
        }
      }
    end

    it 'should add the extra rel attribute together with the default ones' do
      expect(post_with_external_markdown_link.output).to include(para('Link to <a href="https://google.com" target="_blank" rel="noopener noreferrer nofollow">Google</a>.'))
    end
  end

  context 'When more than one additional rel attributes are added in config' do
    let(:rel_attribute) { 'nofollow tag' }
    let(:config_overrides) do
      {
        'target-blank' => {
          'add_css_classes' => false,
          'rel' => rel_attribute
        }
      }
    end

    it 'should add the extra rel attributes together with the default ones' do
      expect(post_with_external_markdown_link.output).to include(para('Link to <a href="https://google.com" target="_blank" rel="noopener noreferrer nofollow tag">Google</a>.'))
    end
  end

  context 'When one extra rel attribute value are set in config and noopener is set to false' do
    let(:rel_attribute) { 'nofollow' }
    let(:noopener) { false }
    let(:config_overrides) do
      {
        'target-blank' => {
          'add_css_classes' => false,
          'noopener' => noopener,
          'rel' => rel_attribute
        }
      }
    end

    it 'should the extra rel attribute value and not add the default noopener value' do
      expect(post_with_external_markdown_link.output).to include(para('Link to <a href="https://google.com" target="_blank" rel="noreferrer nofollow">Google</a>.'))
    end
  end

  context 'When more than one extra rel attribute values are set in config and noopener is set to false' do
    let(:rel_attribute) { 'nofollow tag' }
    let(:noopener) { false }
    let(:config_overrides) do
      {
        'target-blank' => {
          'add_css_classes' => false,
          'noopener' => noopener,
          'rel' => rel_attribute
        }
      }
    end

    it 'should the extra rel attribute values and not add the default noopener value' do
      expect(post_with_external_markdown_link.output).to include(para('Link to <a href="https://google.com" target="_blank" rel="noreferrer nofollow tag">Google</a>.'))
    end
  end

  context 'When one extra rel attributes is set in config and both noopener and noreferer are set to false' do
    let(:rel_attribute) { 'nofollow' }
    let(:noopener) { false }
    let(:noreferrer) { false }
    let(:config_overrides) do
      {
        'target-blank' => {
          'add_css_classes' => false,
          'noopener' => noopener,
          'noreferrer' => noreferrer,
          'rel' => rel_attribute
        }
      }
    end

    it 'should add the extra rel attribute value and no default ones' do
      expect(post_with_external_markdown_link.output).to include(para('Link to <a href="https://google.com" target="_blank" rel="nofollow">Google</a>.'))
    end
  end

  context 'When more than one extra rel attribute values are set in config and both noopener and noreferer are set to false' do
    let(:rel_attribute) { 'nofollow tag' }
    let(:noopener) { false }
    let(:noreferrer) { false }
    let(:config_overrides) do
      {
        'target-blank' => {
          'add_css_classes' => false,
          'noopener' => noopener,
          'noreferrer' => noreferrer,
          'rel' => rel_attribute
        }
      }
    end

    it 'should add the extra rel attribute values and no default ones' do
      expect(post_with_external_markdown_link.output).to include(para('Link to <a href="https://google.com" target="_blank" rel="nofollow tag">Google</a>.'))
    end
  end

  context 'When noopener is set to false in config but added to the rel config property' do
    let(:rel_attribute) { 'noopener' }
    let(:noopener) { false }
    let(:config_overrides) do
      {
        'target-blank' => {
          'add_css_classes' => false,
          'noopener' => noopener,
          'rel' => rel_attribute
        }
      }
    end

    it 'should still include the noopener rel attribute value' do
      expect(post_with_external_markdown_link.output).to include(para('Link to <a href="https://google.com" target="_blank" rel="noreferrer noopener">Google</a>.'))
    end
  end

  context 'When noopener is set to false in config but added t0 the rel config property alongside one more extra rel attribute value.' do
    let(:rel_attribute) { 'noopener nofollow' }
    let(:noopener) { false }
    let(:config_overrides) do
      {
        'target-blank' => {
          'add_css_classes' => false,
          'noopener' => noopener,
          'rel' => rel_attribute
        }
      }
    end

    it 'should still include the noopener rel attribute value along the extra one' do
      expect(post_with_external_markdown_link.output).to include(para('Link to <a href="https://google.com" target="_blank" rel="noreferrer noopener nofollow">Google</a>.'))
    end
  end

  private

  def post_with_layout_result
    <<~RESULT
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
      <p>Link to <a href="https://google.com" target="_blank" rel="noopener noreferrer">Google</a>.</p>

          <div>Layout content ended.</div>
      </body>
      </html>
    RESULT
  end
end
