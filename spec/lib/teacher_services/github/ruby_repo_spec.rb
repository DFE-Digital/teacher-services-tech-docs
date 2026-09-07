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
    repo = described_class.new(repo_name: "my_test_repo", service_name: "my service", client:)

    expect(repo.profile.tech_stack).to include(
      "rails" => "7.0.4.3",
      "dfe-analytics" => "1.8.1",
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
