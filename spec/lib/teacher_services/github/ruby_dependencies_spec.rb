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

  it "reports yarn version from package.json packageManager" do
    package_json = <<~PACKAGE_JSON
      {
        "packageManager": "yarn@4.9.3"
      }
    PACKAGE_JSON
    deps = described_class.new(service_name, lockfile: empty_gem_file, package_json_file: package_json)

    expect(deps.yarn_version).to eq("4.9.3")
  end

  it "strips the corepack integrity hash from packageManager" do
    package_json = <<~PACKAGE_JSON
      {
        "packageManager": "yarn@4.12.0+sha512.f45ab632439a67f8bc759bf32ead036a1f413287b9042726b7cc4818b7b49e14e9423ba49b18f9e06ea4941c1ad062385b1d8760a8d5091a1a31e5f6219afca8"
      }
    PACKAGE_JSON
    deps = described_class.new(service_name, lockfile: empty_gem_file, package_json_file: package_json)

    expect(deps.yarn_version).to eq("4.12.0")
  end

  it "falls back to tool-versions for yarn version" do
    tool_versions_file = <<~TOOL_VERSIONS
      ruby 3.4.4
      yarn 4.6.0
    TOOL_VERSIONS
    deps = described_class.new(service_name, lockfile: empty_gem_file, tool_versions_file:)

    expect(deps.yarn_version).to eq("4.6.0")
  end

  it "falls back to yarnrc presence for yarn version" do
    deps = described_class.new(service_name, lockfile: empty_gem_file, yarnrc_file: "nodeLinker: node-modules")

    expect(deps.yarn_version).to eq("4.x (yarnrc.yml present)")
  end

  it "reports node version from .node-version" do
    deps = described_class.new(service_name, lockfile: empty_gem_file, node_version_file: "v22.17.0")

    expect(deps.node_version).to eq("22.17.0")
  end

  it "falls back to .tool-versions for node version" do
    tool_versions_file = <<~TOOL_VERSIONS
      ruby 3.4.4
      nodejs 22.17.0
    TOOL_VERSIONS
    deps = described_class.new(service_name, lockfile: empty_gem_file, tool_versions_file:)

    expect(deps.node_version).to eq("22.17.0")
  end

  it "falls back to package.json for node version" do
    package_json = <<~PACKAGE_JSON
      {
        "engines": {
          "node": ">=22.0.0"
        }
      }
    PACKAGE_JSON
    deps = described_class.new(service_name, lockfile: empty_gem_file, package_json_file: package_json)

    expect(deps.node_version).to eq(">=22.0.0")
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

  it "reports postgres version from terraform production.tfvars and postgis from database.tf" do
    terraform_files = {
      "terraform/aks/environments/production.tfvars" => 'postgres_server_version = "16"',
      "terraform/aks/database.tf" => 'extensions = ["postgis"]',
    }
    deps = described_class.new(service_name, lockfile: empty_gem_file, terraform_files:)

    expect(deps.postgres_version).to eq("16 + PostGIS")
  end

  it "falls back to variables.tf default when tfvars is not present" do
    terraform_files = {
      "terraform/application/variables.tf" => <<~TF,
        variable "postgres_version" {
          default = "14"
        }
      TF
    }
    deps = described_class.new(service_name, lockfile: empty_gem_file, terraform_files:)

    expect(deps.postgres_version).to eq("14")
  end

  it "uses hardcoded database server_version when not referencing var" do
    terraform_files = {
      "terraform/database.tf" => 'server_version = "15"',
    }
    deps = described_class.new(service_name, lockfile: empty_gem_file, terraform_files:)

    expect(deps.postgres_version).to eq("15")
  end

  it "returns unknown when no postgres version signal is present" do
    deps = described_class.new(service_name, lockfile: empty_gem_file, terraform_files: {})

    expect(deps.postgres_version).to eq("Unknown")
  end

  it "reports a hardcoded redis version from a redis module block" do
    terraform_files = {
      "terraform/application/main.tf" => <<~TF,
        module "redis" {
          source         = "..."
          server_version = "6.2"
        }
      TF
    }
    deps = described_class.new(service_name, lockfile: empty_gem_file, terraform_files:)

    expect(deps.redis_version).to eq("6.2")
  end

  it "reports a hardcoded redis version from a redis.tf file when there is no redis module" do
    terraform_files = {
      "terraform/redis.tf" => 'server_version = "7.0"',
    }
    deps = described_class.new(service_name, lockfile: empty_gem_file, terraform_files:)

    expect(deps.redis_version).to eq("7.0")
  end

  it "resolves a redis module's version variable from production.tfvars" do
    terraform_files = {
      "terraform/aks/main.tf" => <<~TF,
        module "redis_cache" {
          server_version = var.redis_version
        }
      TF
      "terraform/aks/environments/production.tfvars" => 'redis_version = "6.0"',
    }
    deps = described_class.new(service_name, lockfile: empty_gem_file, terraform_files:)

    expect(deps.redis_version).to eq("6.0")
  end

  it "falls back to the variables.tf default when tfvars is not present" do
    terraform_files = {
      "terraform/application/main.tf" => <<~TF,
        module "redis" {
          server_version = var.redis_version
        }
      TF
      "terraform/application/variables.tf" => <<~TF,
        variable "redis_version" {
          default = "5.0"
        }
      TF
    }
    deps = described_class.new(service_name, lockfile: empty_gem_file, terraform_files:)

    expect(deps.redis_version).to eq("5.0")
  end

  it "reports not pinned when redis is present but no version can be resolved" do
    terraform_files = {
      "terraform/application/main.tf" => <<~TF,
        module "redis" {
          source = "..."
        }
      TF
    }
    deps = described_class.new(service_name, lockfile: empty_gem_file, terraform_files:)

    expect(deps.redis_version).to eq("Not pinned")
  end

  it "reports none when no redis signal is present" do
    deps = described_class.new(service_name, lockfile: empty_gem_file, terraform_files: {})

    expect(deps.redis_version).to eq("None")
  end

  it "reports the alpine version from a literal FROM tag" do
    dockerfile = <<~DOCKERFILE
      FROM ruby:3.2.2-alpine3.19 AS builder
      RUN bundle install
    DOCKERFILE
    deps = described_class.new(service_name, lockfile: empty_gem_file, dockerfile:)

    expect(deps.alpine_version).to eq("3.19")
  end

  it "resolves the alpine version through an ARG default" do
    dockerfile = <<~DOCKERFILE
      ARG RUBY_VERSION=3.2.2-alpine3.19
      FROM ruby:${RUBY_VERSION} AS builder
      RUN bundle install
    DOCKERFILE
    deps = described_class.new(service_name, lockfile: empty_gem_file, dockerfile:)

    expect(deps.alpine_version).to eq("3.19")
  end

  it "reports unspecified when the tag ends in alpine with no version" do
    dockerfile = <<~DOCKERFILE
      FROM ruby:3.2.2-alpine
    DOCKERFILE
    deps = described_class.new(service_name, lockfile: empty_gem_file, dockerfile:)

    expect(deps.alpine_version).to eq("unspecified")
  end

  it "stops at the first stage that resolves to an alpine image" do
    dockerfile = <<~DOCKERFILE
      FROM golang:1.21 AS assets
      FROM ruby:3.2.2-alpine3.19 AS builder
      FROM ruby:3.2.2-alpine3.18 AS runtime
    DOCKERFILE
    deps = described_class.new(service_name, lockfile: empty_gem_file, dockerfile:)

    expect(deps.alpine_version).to eq("3.19")
  end

  it "returns unknown when no FROM line references alpine" do
    dockerfile = <<~DOCKERFILE
      FROM ruby:3.2.2-slim-bullseye
    DOCKERFILE
    deps = described_class.new(service_name, lockfile: empty_gem_file, dockerfile:)

    expect(deps.alpine_version).to eq("Unknown")
  end

  it "returns unknown when there is no Dockerfile" do
    deps = described_class.new(service_name, lockfile: empty_gem_file, dockerfile: nil)

    expect(deps.alpine_version).to eq("Unknown")
  end
end
