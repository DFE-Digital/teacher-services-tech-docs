require "spec_helper"

RSpec.describe TeacherServicesTechDocs::GitHub::RubyDependencies do
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

  it "correctly reports versions" do
    deps = described_class.new(lockfile: lockfile_contents)
    expect(deps.rails_version).to eq("7.0.8")
    expect(deps.dfe_analytics_version).to eq("1.2.0")
    expect(deps.dfe_autocomplete_version).to eq("1.3.0")
    expect(deps.dfe_reference_data_version).to eq("1.4.0")
  end

  it "correctly returns null when a gem is not present" do
    lockfile_without_rails = lockfile_contents.split("\n").reject { |l| l =~ /rails/ }.join("\n")
    deps = described_class.new(lockfile: lockfile_without_rails)
    expect(deps.rails_version).to eq(nil)
  end

  it "falls back to the .ruby-version file if present" do
  end
end
