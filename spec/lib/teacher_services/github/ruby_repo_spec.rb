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
      "asset-management" => "Sprockets 4.2.0",
      "css-compilation" => "Webpack 5.4.4",
      "js-compilation" => "Webpack 5.4.4",
    )
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
