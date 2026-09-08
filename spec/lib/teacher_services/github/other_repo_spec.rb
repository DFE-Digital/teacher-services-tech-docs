require "spec_helper"

RSpec.describe SchoolsDigitalTechDocs::GitHub::OtherRepo do
  it "exposes tech stack as a generic profile shape" do
    repo = described_class.new(repo_name: "my_test_repo", service_name: "my service", language: "other", client: FakeGithubClient.new)

    expect(repo.profile.tech_stack).to eq(
      "language" => "other",
    )
  end

  it "identifies itself by profile type predicates" do
    repo = described_class.new(repo_name: "my_test_repo", service_name: "my service", language: "other", client: FakeGithubClient.new)

    expect(repo.profile.ruby?).to be(false)
    expect(repo.profile.cs?).to be(false)
    expect(repo.profile.other?).to be(true)
  end
end
