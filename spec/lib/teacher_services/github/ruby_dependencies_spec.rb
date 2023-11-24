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
    deps = described_class.new(lockfile_contents)
    expect(deps.rails_version).to eq("7.0.8")
  end

  it "correctly returns null when a gem is not present" do
    lockfile_without_rails = lockfile_contents.split("\n").reject { |l| l =~ /rails/ }.join("\n")
    deps = described_class.new(lockfile_without_rails)
    expect(deps.rails_version).to eq(nil)
  end
end
