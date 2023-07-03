require "spec_helper"

RSpec.describe TeacherServicesTechDocs::GitHub::CsRepo do
  it "parses a csproj file correctly" do
    client = FakeGithubClient.new
    client.stub_repo_file("my_test_repo", "example/file.csproj", File.read("spec/fixtures/qta.csproj"))
    repo = described_class.new(repo_name: "my_test_repo", service_name: "my service", csproj_path: "example/file.csproj", client:)

    expect(repo.profile.target_framework).to eq("net7.0")
  end
end
