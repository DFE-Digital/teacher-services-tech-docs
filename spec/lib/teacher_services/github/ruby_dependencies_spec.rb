require "spec_helper"

RSpec.describe SchoolsDigitalTechDocs::GitHub::RubyDependencies do
  service_name = "my_service"

  let :lockfile_contents do
    <<~GEMFILE_LOCK
      GEM
        remote: https://rubygems.org/
        specs:
          rails (7.0.8)
          dfe-analytics (1.2.0)
          dfe-autocomplete (1.3.0)
          dfe-reference-data (1.4.0)

      RUBY VERSION
        ruby 3.1.2p20
    GEMFILE_LOCK
  end

  empty_gem_file = ""

  let :ruby_version_file do
    <<~TOOL_VERSIONS
      ruby 3.5.4
    TOOL_VERSIONS
  end

  let :simple_tool_version_file do
    <<~TOOL_VERSIONS
      ruby 3.2.4
    TOOL_VERSIONS
  end

  it "correctly reports versions" do
    deps = described_class.new(service_name, lockfile: lockfile_contents)
    expect(deps.rails_version).to eq("7.0.8")
    expect(deps.dfe_analytics_version).to eq("1.2.0")
    expect(deps.dfe_autocomplete_version).to eq("1.3.0")
    expect(deps.dfe_reference_data_version).to eq("1.4.0")
  end

  it "correctly returns null when a gem is not present" do
    lockfile_without_rails = lockfile_contents.split("\n").grep_v(/rails/).join("\n")
    deps = described_class.new(service_name, lockfile: lockfile_without_rails)
    expect(deps.rails_version).to eq(nil)
  end

  it "falls back to the .ruby-version file if present" do
    deps = described_class.new(service_name, lockfile: empty_gem_file, ruby_version_file:)
    expect(deps.ruby_version).to eq("3.5.4")
  end

  it "falls back to the .tool-versions file if present" do
    deps = described_class.new(service_name, lockfile: empty_gem_file, tool_versions_file: simple_tool_version_file)
    expect(deps.ruby_version).to eq("3.2.4")
  end

  let :complex_tool_version_file do
    <<~TOOL_VERSIONS
      ruby 3.4.4
      node 27.6.1
      python 3.13.4
    TOOL_VERSIONS
  end

  it "handles multiple tools defined in the .tool-versions file" do
    deps = described_class.new(service_name, lockfile: empty_gem_file, tool_versions_file: complex_tool_version_file)
    expect(deps.ruby_version).to eq("3.4.4")
  end

  it "handles empty .tool-versions file" do
    deps = described_class.new(service_name, lockfile: empty_gem_file, tool_versions_file: "")
    expect(deps.ruby_version).to eq(nil)
  end

  let :malformed_tool_version_file do
    <<~TOOL_VERSIONS
      ruby 3.2.1
      ruby 3.3.3
    TOOL_VERSIONS
  end

  it "handles empty .tool-versions file" do
    deps = described_class.new(service_name, lockfile: empty_gem_file, tool_versions_file: malformed_tool_version_file)
    expect { deps.ruby_version }.to raise_error(RuntimeError)
  end

  let :no_ruby_tool_version_file do
    <<~TOOL_VERSIONS
      terraform 1.4.6
      dotnet    8.0
    TOOL_VERSIONS
  end

  it "handles .tool-versions file without a Ruby definition" do
    deps = described_class.new(service_name, lockfile: empty_gem_file, tool_versions_file: no_ruby_tool_version_file)
    expect { deps.ruby_version }.to raise_error(RuntimeError)
  end
end
