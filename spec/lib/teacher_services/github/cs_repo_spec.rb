require "spec_helper"

RSpec.describe SchoolsDigitalTechDocs::GitHub::CsRepo do
  it "parses a csproj file correctly" do
    client = FakeGithubClient.new
    client.stub_repo_file("my_test_repo", "example/file.csproj", File.read("spec/fixtures/qta.csproj"))
    repo = described_class.new(repo_name: "my_test_repo", service_name: "my service", csproj_path: "example/file.csproj", client:)

    expect(repo.profile.target_framework).to eq("net7.0")
  end

  it "has the service name associated with it" do
    expected_service_name = "my service"

    client = FakeGithubClient.new
    client.stub_repo_file("my_test_repo", "example/file.csproj", File.read("spec/fixtures/qta.csproj"))
    repo = described_class.new(repo_name: "my_test_repo", service_name: expected_service_name, csproj_path: "example/file.csproj", client:)

    expect(repo.service_name).to eq(expected_service_name)
  end

  it "exposes tech stack as a generic profile shape" do
    client = FakeGithubClient.new
    client.stub_repo_file("my_test_repo", "example/file.csproj", File.read("spec/fixtures/qta.csproj"))
    repo = described_class.new(repo_name: "my_test_repo", service_name: "my service", csproj_path: "example/file.csproj", client:)

    expect(repo.profile.tech_stack).to eq(
      "framework" => "net7.0",
      "dfe-analytics-net" => nil,
    )
  end

  it "identifies itself by profile type predicates" do
    client = FakeGithubClient.new
    client.stub_repo_file("my_test_repo", "example/file.csproj", File.read("spec/fixtures/qta.csproj"))
    repo = described_class.new(repo_name: "my_test_repo", service_name: "my service", csproj_path: "example/file.csproj", client:)

    expect(repo.profile.ruby?).to be(false)
    expect(repo.profile.cs?).to be(true)
    expect(repo.profile.other?).to be(false)
  end
end
