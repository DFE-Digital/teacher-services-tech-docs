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
require "teacher_services_tech_docs/github/repo"
require "teacher_services_tech_docs/github/markdown_file"

module TeacherServicesTechDocs
  GITHUB_TOKEN = ENV.fetch("GITHUB_TOKEN")
end