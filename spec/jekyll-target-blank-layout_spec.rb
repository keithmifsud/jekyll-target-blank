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

end
