require "spec_helper"

RSpec.describe SchoolsDigitalTechDocs::GitHub::RubyDependencies do
  service_name = "my_service"

  let :lockfile_contents do
    <<~GEMFILE_LOCK
      GEM
        remote: https://rubygems.org/
        specs:
          rails (7.0.8)
          dfe-analytics (1.2.0)
          dfe-autocomplete (1.3.0)
          dfe-reference-data (1.4.0)

      RUBY VERSION
        ruby 3.1.2p20
    GEMFILE_LOCK
  end

  empty_gem_file = ""

  let :ruby_version_file do
    <<~TOOL_VERSIONS
      ruby 3.5.4
    TOOL_VERSIONS
  end

  let :simple_tool_version_file do
    <<~TOOL_VERSIONS
      ruby 3.2.4
    TOOL_VERSIONS
  end

  it "correctly reports versions" do
    deps = described_class.new(service_name, lockfile: lockfile_contents)
    expect(deps.rails_version).to eq("7.0.8")
    expect(deps.dfe_analytics_version).to eq("1.2.0")
    expect(deps.dfe_autocomplete_version).to eq("1.3.0")
    expect(deps.dfe_reference_data_version).to eq("1.4.0")
  end

  it "reports Airbyte only when the gem is absent but airbyte is enabled" do
    lockfile_without_dfe_analytics = lockfile_contents.split("\n").grep_v(/dfe-analytics/).join("\n")
    dfe_analytics_initializer_file = <<~RUBY
      DfE::Analytics.configure do |config|
        config.airbyte_enabled = true
      end
    RUBY

    deps = described_class.new(
      service_name,
      lockfile: lockfile_without_dfe_analytics,
      dfe_analytics_initializer_file:
    )

    expect(deps.dfe_analytics_version).to eq("Airbyte")
  end

  it "reports gem and Airbyte when both are present" do
    dfe_analytics_initializer_file = <<~RUBY
      DfE::Analytics.configure do |config|
        config.airbyte_enabled = true
      end
    RUBY

    deps = described_class.new(
      service_name,
      lockfile: lockfile_contents,
      dfe_analytics_initializer_file:
    )

    expect(deps.dfe_analytics_version).to eq("1.2.0 + Airbyte")
  end

  it "does not report Airbyte when disabled in the initializer" do
    dfe_analytics_initializer_file = <<~RUBY
      DfE::Analytics.configure do |config|
        config.airbyte_enabled = false
      end
    RUBY

    deps = described_class.new(
      service_name,
      lockfile: lockfile_contents,
      dfe_analytics_initializer_file:
    )

    expect(deps.dfe_analytics_version).to eq("1.2.0")
  end

  it "returns nil when dfe-analytics is absent from Gemfile.lock" do
    lockfile_without_dfe_analytics = lockfile_contents.split("\n").grep_v(/dfe-analytics/).join("\n")
    deps = described_class.new(service_name, lockfile: lockfile_without_dfe_analytics)

    expect(deps.dfe_analytics_version).to eq(nil)
  end

  it "correctly returns null when a gem is not present" do
    lockfile_without_rails = lockfile_contents.split("\n").grep_v(/rails/).join("\n")
    deps = described_class.new(service_name, lockfile: lockfile_without_rails)
    expect(deps.rails_version).to eq(nil)
  end

  it "falls back to the .ruby-version file if present" do
    deps = described_class.new(service_name, lockfile: empty_gem_file, ruby_version_file:)
    expect(deps.ruby_version).to eq("3.5.4")
  end

  it "falls back to the .tool-versions file if present" do
    deps = described_class.new(service_name, lockfile: empty_gem_file, tool_versions_file: simple_tool_version_file)
    expect(deps.ruby_version).to eq("3.2.4")
  end

  let :complex_tool_version_file do
    <<~TOOL_VERSIONS
      ruby 3.4.4
      node 27.6.1
      python 3.13.4
    TOOL_VERSIONS
  end

  it "handles multiple tools defined in the .tool-versions file" do
    deps = described_class.new(service_name, lockfile: empty_gem_file, tool_versions_file: complex_tool_version_file)
    expect(deps.ruby_version).to eq("3.4.4")
  end

  it "handles empty .tool-versions file" do
    deps = described_class.new(service_name, lockfile: empty_gem_file, tool_versions_file: "")
    expect(deps.ruby_version).to eq(nil)
  end

  let :malformed_tool_version_file do
    <<~TOOL_VERSIONS
      ruby 3.2.1
      ruby 3.3.3
    TOOL_VERSIONS
  end

  it "handles empty .tool-versions file" do
    deps = described_class.new(service_name, lockfile: empty_gem_file, tool_versions_file: malformed_tool_version_file)
    expect { deps.ruby_version }.to raise_error(RuntimeError)
  end

  let :no_ruby_tool_version_file do
    <<~TOOL_VERSIONS
      terraform 1.4.6
      dotnet    8.0
    TOOL_VERSIONS
  end

  it "handles .tool-versions file without a Ruby definition" do
    deps = described_class.new(service_name, lockfile: empty_gem_file, tool_versions_file: no_ruby_tool_version_file)
    expect { deps.ruby_version }.to raise_error(RuntimeError)
  end

  it "reports cssbundling and Sass versions from Gemfile.lock" do
    lockfile = <<~GEMFILE_LOCK
      GEM
        remote: https://rubygems.org/
        specs:
          cssbundling-rails (1.4.1)
          sassc-rails (2.1.2)

      RUBY VERSION
        ruby 3.2.2p53
    GEMFILE_LOCK

    deps = described_class.new(service_name, lockfile:)

    expect(deps.css_compilation).to eq("cssbundling-rails 1.4.1 + Sass 2.1.2")
  end

  it "reports Shakapacker and Sass versions from yarn.lock" do
    lockfile = <<~GEMFILE_LOCK
      GEM
        remote: https://rubygems.org/
        specs:
          shakapacker (8.2.1)
    GEMFILE_LOCK
    package_json = <<~PACKAGE_JSON
      {
        "dependencies": {
          "shakapacker": "^8.2.1",
          "sass": "^1.89.0"
        }
      }
    PACKAGE_JSON
    yarn_lock = <<~YARN_LOCK
      "sass@^1.89.0":
        version "1.89.2"
        resolved "https://registry.yarnpkg.com/sass/-/sass-1.89.2.tgz"

      "shakapacker@^8.2.1":
        version "8.2.3"
        resolved "https://registry.yarnpkg.com/shakapacker/-/shakapacker-8.2.3.tgz"
    YARN_LOCK

    deps = described_class.new(service_name, lockfile:, package_json_file: package_json, yarn_lock_file: yarn_lock)

    expect(deps.css_compilation).to eq("Shakapacker 8.2.3 + Sass 1.89.2")
  end

  it "reports Webpack and Sass loader when Sass package is not present" do
    package_json = <<~PACKAGE_JSON
      {
        "devDependencies": {
          "webpack": "~5.99.0",
          "sass-loader": "^14.2.1"
        }
      }
    PACKAGE_JSON
    yarn_lock = <<~YARN_LOCK
      "sass-loader@^14.2.1":
        version "14.2.2"
        resolved "https://registry.yarnpkg.com/sass-loader/-/sass-loader-14.2.2.tgz"

      "webpack@~5.99.0":
        version "5.99.1"
        resolved "https://registry.yarnpkg.com/webpack/-/webpack-5.99.1.tgz"
    YARN_LOCK

    deps = described_class.new(service_name, lockfile: empty_gem_file, package_json_file: package_json, yarn_lock_file: yarn_lock)

    expect(deps.css_compilation).to eq("Webpack 5.99.1 + Sass (sass-loader 14.2.2)")
  end

  it "reports Webpack JS compilation from shakapacker in yarn.lock" do
    lockfile = <<~GEMFILE_LOCK
      GEM
        remote: https://rubygems.org/
        specs:
          shakapacker (8.2.1)
    GEMFILE_LOCK
    package_json = <<~PACKAGE_JSON
      {
        "dependencies": {
          "shakapacker": "^8.2.1"
        }
      }
    PACKAGE_JSON
    yarn_lock = <<~YARN_LOCK
      "shakapacker@^8.2.1":
        version "8.2.3"
        resolved "https://registry.yarnpkg.com/shakapacker/-/shakapacker-8.2.3.tgz"
    YARN_LOCK

    deps = described_class.new(service_name, lockfile:, package_json_file: package_json, yarn_lock_file: yarn_lock)

    expect(deps.js_compilation).to eq("Webpack 8.2.3")
  end

  it "reports esbuild JS compilation from jsbundling-rails and yarn.lock" do
    lockfile = <<~GEMFILE_LOCK
      GEM
        remote: https://rubygems.org/
        specs:
          jsbundling-rails (1.3.1)
    GEMFILE_LOCK
    package_json = <<~PACKAGE_JSON
      {
        "scripts": {
          "build:js": "esbuild app/javascript/* --bundle"
        },
        "devDependencies": {
          "esbuild": "^0.23.1"
        }
      }
    PACKAGE_JSON
    yarn_lock = <<~YARN_LOCK
      "esbuild@^0.23.1":
        version "0.23.2"
        resolved "https://registry.yarnpkg.com/esbuild/-/esbuild-0.23.2.tgz"
    YARN_LOCK

    deps = described_class.new(service_name, lockfile:, package_json_file: package_json, yarn_lock_file: yarn_lock)

    expect(deps.js_compilation).to eq("esbuild 0.23.2")
  end

  it "returns none detected when no JS compiler signal is present" do
    deps = described_class.new(service_name, lockfile: empty_gem_file, package_json_file: "{}")

    expect(deps.js_compilation).to eq("None detected")
  end

  it "reports all supported asset management pipelines from Gemfile.lock" do
    lockfile = <<~GEMFILE_LOCK
      GEM
        remote: https://rubygems.org/
        specs:
          propshaft (1.2.0)
          shakapacker (8.2.1)
          sprockets-rails (3.5.2)
    GEMFILE_LOCK

    deps = described_class.new(service_name, lockfile:)

    expect(deps.asset_management).to eq("Shakapacker 8.2.1, Propshaft 1.2.0, Sprockets 3.5.2")
  end

  it "returns unknown when no supported asset management gem is present" do
    deps = described_class.new(service_name, lockfile: lockfile_contents)

    expect(deps.asset_management).to eq("Unknown")
  end

  it "reports all supported job queues from Gemfile.lock" do
    lockfile = <<~GEMFILE_LOCK
      GEM
        remote: https://rubygems.org/
        specs:
          sidekiq (7.3.0)
          solid_queue (1.2.0)
          good_job (4.6.1)
    GEMFILE_LOCK

    deps = described_class.new(service_name, lockfile:)

    expect(deps.job_queues).to eq("Sidekiq 7.3.0, SolidQueue 1.2.0, GoodJob 4.6.1")
  end

  it "returns none for job queues when no supported gems are present" do
    deps = described_class.new(service_name, lockfile: lockfile_contents)

    expect(deps.job_queues).to eq("None")
  end

  it "reports caching signals from lockfile and production environment config" do
    lockfile = <<~GEMFILE_LOCK
      GEM
        remote: https://rubygems.org/
        specs:
          solid_cache (1.1.0)
          redis (5.4.0)
    GEMFILE_LOCK
    production_environment_file = <<~RUBY
      config.cache_store = :redis_cache_store
      config.cache_store = :mem_cache_store
      config.cache_store = :solid_cache_store
    RUBY

    deps = described_class.new(service_name, lockfile:, production_environment_file:)

    expect(deps.caching).to eq("SolidCache 1.1.0, Redis, Memcache")
  end

  it "returns unknown for caching when no cache signal is present" do
    deps = described_class.new(service_name, lockfile: lockfile_contents)

    expect(deps.caching).to eq("Unknown")
  end
end
