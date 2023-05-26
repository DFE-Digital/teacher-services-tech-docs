require "spec_helper"

RSpec.describe TeacherServicesTechDocs::GitHub::CsRepo do
  class FakeGithubClient
    File = Struct.new(:contents)
    Repo = Struct.new(:default_branch)

    def initialize
      @repo_stubs = {}
    end

    def get_file(repo, file)
      raise unless @repo_stubs[repo]

      if @repo_stubs[repo].fetch(file, nil)
        File.new(@repo_stubs[repo][file])
      end
    end

    def get_repo(_reponame)
      Repo.new("main")
    end

    def stub_repo_file(repo, file, contents)
      unless @repo_stubs[repo]
        @repo_stubs[repo] = {}
      end
      @repo_stubs[repo][file] = contents
    end
  end

  it "parses a csproj file correctly" do
    client = FakeGithubClient.new
    file = File.read("spec/fixtures/qta.csproj")
    client.stub_repo_file("my_test_repo", "example/file.csproj", File.read("spec/fixtures/qta.csproj"))
    repo = described_class.new(repo_name: "my_test_repo", service_name: "my service", csproj_path: "example/file.csproj", client:)

    expect(repo.profile.target_framework).to eq("net7.0")
  end
end
