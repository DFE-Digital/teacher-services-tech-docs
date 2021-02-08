require "govuk_tech_docs"

require_relative "lib/requires"

GovukTechDocs.configure(self)

SERVICE_DOCS = [
  {
    title: "Teacher Training API documentation",
    pages: GitHubRepoFetcher.instance.docs(
      service_name: "Teacher Training API",
      repo_name: "DFE-Digital/teacher-training-api",
      path_in_repo: "docs",
      path_prefix: "services/teacher-training-api",
      ignore_files: %w[api.md],
    ),
  },
  {
    title: "Teacher Training API decisions",
    pages: GitHubRepoFetcher.instance.docs(
      service_name: "Teacher Training API",
      repo_name: "DFE-Digital/teacher-training-api",
      path_in_repo: "docs/adr",
      path_prefix: "services/teacher-training-api",
      ignore_files: %w[index.md],
    ),
  },
  {
    title: "Find teacher training",
    pages: GitHubRepoFetcher.instance.docs(
      service_name: "Find teacher training",
      repo_name: "DFE-Digital/find-teacher-training",
      path_in_repo: "docs",
      path_prefix: "services/find-teacher-training",
    ),
  },
  {
    title: "Register trainee teachers",
    pages: GitHubRepoFetcher.instance.docs(
      service_name: "Register trainee teachers",
      repo_name: "DFE-Digital/register-trainee-teachers",
      path_in_repo: "docs",
      path_prefix: "services/register-trainee-teachers",
    ),
  },
  {
    title: "Register trainee teachers decisions",
    pages: GitHubRepoFetcher.instance.docs(
      service_name: "Register trainee teachers",
      repo_name: "DFE-Digital/register-trainee-teachers",
      path_in_repo: "docs/adr",
      path_prefix: "services/register-trainee-teachers",
      ignore_files: %w[index.md],
    ),
  },
  {
    title: "Apply for teacher training documentation",
    pages: GitHubRepoFetcher.instance.docs(
      service_name: "Apply for teacher training",
      repo_name: "DFE-Digital/apply-for-teacher-training",
      path_in_repo: "docs",
      path_prefix: "services/apply-for-teacher-training",
    ),
  },
  {
    title: "Apply for teacher training decisions",
    pages: GitHubRepoFetcher.instance.docs(
      service_name: "Apply for teacher training",
      repo_name: "DFE-Digital/apply-for-teacher-training",
      path_in_repo: "adr",
      path_prefix: "services/apply-for-teacher-training",
    ),
  },
].freeze

ignore "templates/*"

helpers do
  def service_docs
    SERVICE_DOCS
  end

  def pages_by_category
    PagesByCategory.new(sitemap)
  end
end

SERVICE_DOCS.each do |service_doc|
  service_doc[:pages].each do |page|
    proxy page.fetch(:path), "templates/external_doc_template.html", page.fetch(:proxy_args)
  end
end
