require "spec_helper"

RSpec.describe SchoolsDigitalTechDocs::GitHub::RubyRepo do
  it "parses a Gemfile.lock correctly" do
    client = FakeGithubClient.new
    client.stub_repo_file("my_test_repo", "Gemfile.lock", File.read("spec/fixtures/Gemfile.lock"))
    repo = described_class.new(repo_name: "my_test_repo", service_name: "my service", client:)

    expect(repo.profile.rails_version).to eq("7.0.4.3")
  end

  it "exposes tech stack as a generic profile shape" do
    client = FakeGithubClient.new
    client.stub_repo_file("my_test_repo", "Gemfile.lock", File.read("spec/fixtures/Gemfile.lock"))
    client.stub_repo_file("my_test_repo", ".node-version", "22.17.0")
    client.stub_repo_file("my_test_repo", "package.json", '{"packageManager":"yarn@4.9.3"}')
    client.stub_repo_file("my_test_repo", "Dockerfile", "FROM ruby:3.2.2-alpine3.19\n")
    repo = described_class.new(repo_name: "my_test_repo", service_name: "my service", client:)

    expect(repo.profile.tech_stack).to include(
      "rails" => "7.0.4.3",
      "node" => "22.17.0",
      "yarn" => "4.9.3",
      "dfe-analytics" => "1.8.1",
      "job-queues" => "Sidekiq 6.5.8",
      "caching" => "Redis",
      "postgres" => "Unknown",
      "redis" => "None",
      "alpine" => "3.19",
      "asset-management" => "Sprockets 4.2.0",
      "css-compilation" => "Webpack 5.4.4",
      "js-compilation" => "Webpack 5.4.4",
    )
  end

  it "orders tech stack with primary technologies first, then the rest alphabetically" do
    client = FakeGithubClient.new
    client.stub_repo_file("my_test_repo", "Gemfile.lock", File.read("spec/fixtures/Gemfile.lock"))
    repo = described_class.new(repo_name: "my_test_repo", service_name: "my service", client:)

    primary = %w[ruby rails postgres alpine node yarn redis]
    rest = %w[asset-management caching css-compilation dfe-analytics dfe-autocomplete dfe-reference-data job-queues js-compilation]

    expect(repo.profile.tech_stack.keys).to eq(primary + rest)
  end

  it "exposes only the primary technologies via primary_tech_stack" do
    client = FakeGithubClient.new
    client.stub_repo_file("my_test_repo", "Gemfile.lock", File.read("spec/fixtures/Gemfile.lock"))
    client.stub_repo_file("my_test_repo", "Dockerfile", "FROM ruby:3.2.2-alpine3.19\n")
    repo = described_class.new(repo_name: "my_test_repo", service_name: "my service", client:)

    expect(repo.profile.primary_tech_stack).to eq(
      "ruby" => "3.1.2",
      "rails" => "7.0.4.3",
      "postgres" => "Unknown",
      "alpine" => "3.19",
      "node" => nil,
      "yarn" => nil,
      "redis" => "None",
    )
  end

  it "discovers terraform files from the repo tree via get_tree_paths and excludes vendor paths" do
    client = FakeGithubClient.new
    client.stub_repo_file("my_test_repo", "Gemfile.lock", File.read("spec/fixtures/Gemfile.lock"))
    client.stub_repo_file("my_test_repo", "terraform/aks/environments/production.tfvars", 'postgres_server_version = "16"')
    client.stub_repo_file("my_test_repo", "terraform/aks/redis.tf", 'server_version = "6.2"')
    client.stub_repo_file("my_test_repo", "terraform/aks/vendor/legacy/database.tf", 'server_version = "99"')
    repo = described_class.new(repo_name: "my_test_repo", service_name: "my service", client:)

    expect(repo.profile.postgres_version).to eq("16")
    expect(repo.profile.redis_version).to eq("6.2")
  end

  it "identifies itself by profile type predicates" do
    client = FakeGithubClient.new
    client.stub_repo_file("my_test_repo", "Gemfile.lock", File.read("spec/fixtures/Gemfile.lock"))
    repo = described_class.new(repo_name: "my_test_repo", service_name: "my service", client:)

    expect(repo.profile.ruby?).to be(true)
    expect(repo.profile.cs?).to be(false)
    expect(repo.profile.other?).to be(false)
  end
end
