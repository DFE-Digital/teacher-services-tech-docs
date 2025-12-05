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

# utilities
require "teacher_services_tech_docs/pages_by_category"

# business
require "teacher_services_tech_docs/github/client"
require "teacher_services_tech_docs/github/markdown_docs"
require "teacher_services_tech_docs/github/ruby_repo"
require "teacher_services_tech_docs/github/cs_repo"
require "teacher_services_tech_docs/github/file"
require "teacher_services_tech_docs/github/markdown_file"
require "teacher_services_tech_docs/github/ruby_dependencies"
require "teacher_services_tech_docs/github/cs_dependencies"

module SchoolsDigitalTechDocs
  GITHUB_TOKEN = ENV.fetch("GITHUB_TOKEN")
end
