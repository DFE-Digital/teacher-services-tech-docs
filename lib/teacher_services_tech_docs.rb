$LOAD_PATH.unshift "./lib"

# deps
require "dotenv"

if ENV["TECH_DOCS_BUILD_ENV"] == "test"
  Dotenv.load(".env.test")
else
  Dotenv.load(".env")
end

require "govuk_tech_docs"
require "yaml"
require "pry"
require "octokit"
require "faraday"
require "faraday_middleware"
require "html/pipeline"
require "uri"
require "forwardable"

# utilities
require "teacher_services_tech_docs/pages_by_category"

# business
require "teacher_services_tech_docs/github/client"
require "teacher_services_tech_docs/github/markdown_docs"
require "teacher_services_tech_docs/github/repo_profiles"
require "teacher_services_tech_docs/github/ruby/profile"
require "teacher_services_tech_docs/github/cs/profile"
require "teacher_services_tech_docs/github/other/profile"
require "teacher_services_tech_docs/github/ruby/repo"
require "teacher_services_tech_docs/github/cs/repo"
require "teacher_services_tech_docs/github/other/repo"
require "teacher_services_tech_docs/github/repo_factory"
require "teacher_services_tech_docs/github/file"
require "teacher_services_tech_docs/github/markdown_file"
require "teacher_services_tech_docs/github/ruby/dependencies/dependency_detector_base"
require "teacher_services_tech_docs/github/ruby/dependencies/asset_management"
require "teacher_services_tech_docs/github/ruby/dependencies/caching"
require "teacher_services_tech_docs/github/ruby/dependencies/css_compilation"
require "teacher_services_tech_docs/github/ruby/dependencies/dfe_analytics"
require "teacher_services_tech_docs/github/ruby/dependencies/js_compilation"
require "teacher_services_tech_docs/github/ruby/dependencies/job_queues"
require "teacher_services_tech_docs/github/ruby/dependencies/ruby_version"
require "teacher_services_tech_docs/github/ruby/dependencies/node_version"
require "teacher_services_tech_docs/github/ruby/dependencies/yarn_version"
require "teacher_services_tech_docs/github/ruby/dependencies/postgres_version"
require "teacher_services_tech_docs/github/ruby/dependencies/redis_version"
require "teacher_services_tech_docs/github/ruby/dependencies/alpine_version"
require "teacher_services_tech_docs/github/ruby/dependencies"
require "teacher_services_tech_docs/github/cs/dependencies"

module SchoolsDigitalTechDocs
  GITHUB_TOKEN = ENV.fetch("GITHUB_TOKEN")
end
