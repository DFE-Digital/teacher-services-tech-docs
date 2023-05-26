require "webmock/rspec"

require "govuk_tech_docs"

require_relative 'helpers/fake_github_client.rb'

ENV["TECH_DOCS_BUILD_ENV"] = "test"
require_relative "../lib/teacher_services_tech_docs"
