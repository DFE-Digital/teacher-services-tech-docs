require "spec_helper"

RSpec.describe SchoolsDigitalTechDocs::GitHub::RubyRepo do
  it "parses a Gemfile.lock correctly" do
    client = FakeGithubClient.new
    client.stub_repo_file("my_test_repo", "Gemfile.lock", File.read("spec/fixtures/Gemfile.lock"))
    repo = described_class.new(repo_name: "my_test_repo", service_name: "my service", client:)

    expect(repo.profile.rails).to eq("7.0.4.3")
  end
end
