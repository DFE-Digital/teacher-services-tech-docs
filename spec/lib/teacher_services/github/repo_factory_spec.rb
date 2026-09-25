require "spec_helper"

RSpec.describe SchoolsDigitalTechDocs::GitHub::RepoFactory do
  let(:client) { FakeGithubClient.new }

  it "builds a Ruby repo for ruby services" do
    repo = described_class.build(
      service: {
        "name" => "my service",
        "repo_name" => "my_test_repo",
        "language" => "ruby",
      },
      client:,
    )

    expect(repo).to be_a(SchoolsDigitalTechDocs::GitHub::RubyRepo)
  end

  it "builds a C# repo for cs services" do
    repo = described_class.build(
      service: {
        "name" => "my service",
        "repo_name" => "my_test_repo",
        "language" => "cs",
        "csproj_path" => "example/file.csproj",
      },
      client:,
    )

    expect(repo).to be_a(SchoolsDigitalTechDocs::GitHub::CsRepo)
  end

  it "builds an Other repo for other services" do
    repo = described_class.build(
      service: {
        "name" => "my service",
        "repo_name" => "my_test_repo",
        "language" => "other",
      },
      client:,
    )

    expect(repo).to be_a(SchoolsDigitalTechDocs::GitHub::OtherRepo)
  end

  it "raises for unsupported languages" do
    expect {
      described_class.build(
        service: {
          "name" => "my service",
          "repo_name" => "my_test_repo",
          "language" => "go",
        },
        client:,
      )
    }.to raise_error("Unsupported language 'go' for my service")
  end
end
