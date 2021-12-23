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
      ignore_files: %w[index.md template.md],
    ),
  },
  {
    title: "Apply for teacher training documentation",
    pages: GitHubRepoFetcher.instance.docs(
      service_name: "Apply for teacher training",
      repo_name: "DFE-Digital/apply-for-teacher-training",
      branch: "main",
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
  {
    title: "Teaching vacancies documentation",
    pages: GitHubRepoFetcher.instance.docs(
      service_name: "Teaching vacancies",
      repo_name: "DFE-Digital/teaching-vacancies",
      path_in_repo: "documentation",
      path_prefix: "services/teaching-vacancies",
    ),
  },
  {
    title: "Teaching vacancies decisions",
    pages: GitHubRepoFetcher.instance.docs(
      service_name: "Teaching vacancies",
      repo_name: "DFE-Digital/teaching-vacancies",
      path_in_repo: "documentation/adr",
      path_prefix: "services/teaching-vacancies",
    ),
  },
  {
    title: "Get Into Teaching application documentation",
    pages: GitHubRepoFetcher.instance.docs(
      service_name: "Get Into Teaching",
      repo_name: "DFE-Digital/get-into-teaching-app",
      path_in_repo: "docs",
      path_prefix: "services/get-into-teaching",
    ),
  },
  {
    title: "Get Into Teaching API documentation",
    pages: GitHubRepoFetcher.instance.docs(
      service_name: "Get Into Teaching",
      repo_name: "DFE-Digital/get-into-teaching-api",
      path_in_repo: "docs",
      path_prefix: "services/get-into-teaching",
    ),
  },
  {
    title: "Get Teacher Training Adviser documentation",
    pages: GitHubRepoFetcher.instance.docs(
      service_name: "Get Into Teaching",
      repo_name: "DFE-Digital/get-teacher-training-adviser-service",
      path_in_repo: "docs",
      path_prefix: "services/get-into-teaching",
    ),
  },
  {
    title: "Get Into Teaching Asset Manager",
    pages: GitHubRepoFetcher.instance.docs(
      service_name: "Get Into Teaching",
      repo_name: "DFE-Digital/GITISContent",
      path_in_repo: "docs",
      path_prefix: "services/get-into-teaching",
    ),
  },
  {
    title: "Get School Experience documentation",
    pages: GitHubRepoFetcher.instance.docs(
      service_name: "Get School Experience",
      repo_name: "DFE-Digital/schools-experience",
      path_in_repo: "doc",
      path_prefix: "services/school-experience",
    ),
  },
  {
    title: "Monitoring",
    pages: GitHubRepoFetcher.instance.docs(
      service_name: "Infrastructure",
      repo_name: "DFE-Digital/cf-monitoring",
      path_in_repo: "",
      path_prefix: "services/cf-monitoring",
    ),
  },
  {
    title: "Github Actions",
    pages: GitHubRepoFetcher.instance.docs(
      service_name: "Infrastructure",
      repo_name: "DFE-Digital/github-actions",
      path_in_repo: "",
      path_prefix: "services/github-actions",
    ),
  },
  {
    title: "Infrastructure",
    pages: GitHubRepoFetcher.instance.docs(
      service_name: "Infrastructure",
      repo_name: "DFE-Digital/bat-infrastructure",
      path_in_repo: "",
      path_prefix: "services/bat-infrastructure",
    ),
  },
  {
    title: "Qualified Teachers API documentation",
    pages: GitHubRepoFetcher.instance.docs(
      service_name: "Qualified Teachers API",
      repo_name: "DFE-Digital/qualified-teachers-api",
      path_in_repo: "docs",
      path_prefix: "services/qualified-teachers-api",
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
