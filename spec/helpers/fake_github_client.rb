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

