# frozen_string_literal: true

RSpec.describe(Jekyll::TargetBlank) do

  Jekyll.logger.log_level = :error

  let(:config_overrides) { {} }

  let(:configs) do
    Jekyll.configuration(config_overrides.merge(
      {
        "skip_config_files" => false,
        "source" => integration_fixtures_dir,
        "destination" => integration_fixtures_dir("_site"),
      }
    ))
  end
  let(:target_blank) { described_class }
  let(:site) { Jekyll::Site.new(configs) }
  let(:posts) { site.posts.docs.sort.reverse }

  let(:basic_post) { find_by_title(posts, "Sample Post") }

  before(:each) do
    site.reset
    site.read
    (site.pages | posts | site.docs_to_write).each { |p| p.content.strip! }
    site.render
  end

  context "With nested layouts" do

    it "should close all HTML elements" do
      expect(basic_post.output).to eq(sample_post_expected_content)
    end

  end

  private

  def sample_post_expected_content
    <<-CONTENT
<!DOCTYPE html>
<html lang="en">

  <head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <link rel="shortcut icon" type="image/png" href="/assets/favicon.png"/>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="/assets/main.css"></head>


  <body>

    <header class="site-header" role="banner">
  <div class="wrapper wrapper-title">
<a rel="author" href="/">
      <img src="/assets/images/Neil-obscure.jpeg" class="header-image">
    </a>
    <a class="site-title" rel="author" href="/">
        Neil Kakkar
      </a>
      <nav class="site-nav">
        <input type="checkbox" id="nav-trigger" class="nav-trigger" />
        <label for="nav-trigger">
          <span class="menu-icon">
            <svg viewBox="0 0 18 15" width="18px" height="15px">
              <path d="M18,1.484c0,0.82-0.665,1.484-1.484,1.484H1.484C0.665,2.969,0,2.304,0,1.484l0,0C0,0.665,0.665,0,1.484,0 h15.032C17.335,0,18,0.665,18,1.484L18,1.484z M18,7.516C18,8.335,17.335,9,16.516,9H1.484C0.665,9,0,8.335,0,7.516l0,0 c0-0.82,0.665-1.484,1.484-1.484h15.032C17.335,6.031,18,6.696,18,7.516L18,7.516z M18,13.516C18,14.335,17.335,15,16.516,15H1.484 C0.665,15,0,14.335,0,13.516l0,0c0-0.82,0.665-1.483,1.484-1.483h15.032C17.335,12.031,18,12.695,18,13.516L18,13.516z"
              />
            </svg>
          </span>
        </label>

        <div class="trigger">
          <a class="page-link" href="/about/">About</a>
          <a class="page-link" href="/blog/">Blog</a>
          <a class="page-link" href="/categories/">Categories</a>
        </div>
      </nav>
    </div>
  </header>
  <main class="page-content" aria-label="Content">
    <div class="wrapper">
      <article class="post h-entry" itemscope itemtype="http://schema.org/BlogPosting">
        <p>post content.</p>
      </article>

    </div>
  </main>
  <footer class="site-footer h-card">
    <data class="u-url" href="/"></data>

    <div class="wrapper">
      <!--<h2 class="footer-heading">Neil Kakkar</h2> -->
      <div class="wrapper">
        <!-- Begin Mailchimp Signup Form -->
        <link href="//cdn-images.mailchimp.com/embedcode/classic-10_7.css" rel="stylesheet" type="text/css">

        <div id="mc_embed_signup">
          <form action="https://neilkakkar.us19.list-manage.com/subscribe/post?u=1d900aa3482a7ed1d443ff659&amp;id=1571f607ca" method="post"
            id="mc-embedded-subscribe-form" name="mc-embedded-subscribe-form" class="validate" target="_blank" novalidate>
            <div id="mc_embed_signup_scroll">
              <h2>Never miss a post again</h2>
              <div class="indicates-required"><span class="asterisk">*</span> indicates required</div>
              <div class="mc-field-group">
                <label for="mce-EMAIL">Email Address <span class="asterisk">*</span>
                </label>
                <input type="email" value="" name="EMAIL" class="required email" id="mce-EMAIL">
              </div>
              <div id="mce-responses" class="clear">
                <div class="response" id="mce-error-response" style="display:none"></div>
                <div class="response" id="mce-success-response" style="display:none"></div>
              </div> <!-- real people should not fill this in and expect good things - do not remove this or risk form bot signups-->
              <div style="position: absolute; left: -5000px;" aria-hidden="true"><input type="text" name="b_1d900aa3482a7ed1d443ff659_1571f607ca"
                  tabindex="-1" value=""></div>
              <div class="clear"><input type="submit" value="Subscribe" name="subscribe" id="mc-embedded-subscribe" class="button"></div>
            </div>
          </form>
        </div>
        <script type='text/javascript' src='//s3.amazonaws.com/downloads.mailchimp.com/js/mc-validate.js'></script>
        <script
          type='text/javascript'>(function ($) { window.fnames = new Array(); window.ftypes = new Array(); fnames[0] = 'EMAIL'; ftypes[0] = 'email'; fnames[1] = 'FNAME'; ftypes[1] = 'text'; fnames[2] = 'LNAME'; ftypes[2] = 'text'; fnames[3] = 'ADDRESS'; ftypes[3] = 'address'; fnames[4] = 'PHONE'; ftypes[4] = 'phone'; fnames[5] = 'BIRTHDAY'; ftypes[5] = 'birthday'; }(jQuery)); var $mcj = jQuery.noConflict(true);</script>
        <!--End mc_embed_signup-->
        <hr><br>
      </div>
      <div class="footer-col-wrapper">
        <div class="footer-col footer-col-1">
          <ul class="contact-list">
            <li class="p-name">Neil Kakkar</li>
            <li>Write (Code). Create. Recurse.</li>
            <li><a class="u-email" href="mailto:neil@neilkakkar.com">neil@neilkakkar.com</a></li>
          </ul>
        </div>

        <div class="footer-col footer-col-2">
          <ul class="social-media-list">
            <li><a href="https://github.com/neilkakkar" target="_blank"><svg class="svg-icon"><use xlink:href="/assets/minima-social-icons.svg#github"></use></svg>
                <span class="username"></span></a></li>
            <li><a href="https://www.linkedin.com/in/neilkakkar" target="_blank"><svg class="svg-icon"><use xlink:href="/assets/minima-social-icons.svg#linkedin"></use></svg>
                <span class="username"></span></a></li>
            <li><a href="https://www.twitter.com/neilkakkar" target="_blank"><svg class="svg-icon"><use xlink:href="/assets/minima-social-icons.svg#twitter"></use></svg>
                <span class="username"></span></a></li>
            <li><a href="https://medium.com/@neilkakkar" target="_blank"><svg class="svg-icon"><use xlink:href="/assets/minima-social-icons.svg#medium"></use></svg>
                <span class="username"></span></a></li>
          </ul>
        </div>

        <div class="footer-col footer-col-3">
          <p>A Life and Tech blog. Currently experimental.

          </p>
        </div>
      </div>
    </div>
  </footer>
</body>
</html>
    CONTENT
  end
end
