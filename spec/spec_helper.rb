# frozen_string_literal: true

require File.expand_path("../lib/jekyll-target-blank.rb", __dir__)

RSpec.configure do |config|
  FIXTURES_DIR = File.expand_path("fixtures", __dir__)
  def fixtures_dir(*paths)
    File.join(FIXTURES_DIR, *paths)
  end

  def find_by_title(docs, title)
    docs.find { |d| d.data["title"] == title}
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.disable_monkey_patching!

  config.warnings = false

  config.order = :random

  Kernel.srand config.seed
end
