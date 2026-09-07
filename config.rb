require_relative "lib/teacher_services_tech_docs"

GovukTechDocs.configure(self)

service_list = YAML.load_file("config/services.yml")

service_page_slug = lambda do |service_name|
  service_name.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/^-|-$/, "")
end

service_repos_with_profiles = service_list.map do |service|
  repo = SchoolsDigitalTechDocs::GitHub::RepoFactory.build(service:)
  profile = repo.profile

  raise "No profile created for #{service}" unless profile

  {
    service:,
    repo:,
    profile:,
  }
end

service_docs = Hash.new { |hash, key| hash[key] = [] }

services = service_repos_with_profiles.reduce([]) do |list, entry|
  service = entry.fetch(:service)
  repo = entry.fetch(:repo)

  docset_pages = service.fetch("docsets", []).map do |docset|
    pages = repo.load_docs(
      path_in_repo: docset["path"],
      ignore_files: docset.fetch("ignore_files", []),
    )

    service_docs[service["name"]].concat(pages)
    pages
  end

  list + docset_pages
end

ignore "templates/*"

SERVICE_REPOS = service_repos_with_profiles.map { |entry| entry.fetch(:repo) }.freeze
SERVICE_PROFILES = service_repos_with_profiles.map { |entry| entry.fetch(:profile) }.freeze
CS_SERVICE_PROFILES = SERVICE_PROFILES.select(&:cs?).sort_by(&:service_name).freeze
RUBY_SERVICE_PROFILES = SERVICE_PROFILES.select(&:ruby?).sort_by(&:service_name).freeze
OTHER_SERVICE_PROFILES = SERVICE_PROFILES.select(&:other?).sort_by(&:service_name).freeze
SERVICE_PROFILES_BY_NAME = (RUBY_SERVICE_PROFILES + CS_SERVICE_PROFILES + OTHER_SERVICE_PROFILES).to_h { |profile| [profile.service_name, profile] }.freeze
SERVICE_DOCS = service_docs.freeze
SERVICE_PAGE_PATHS = service_list.to_h { |service| [service["name"], "/service/#{service_page_slug.call(service["name"])}.html"] }.freeze

ALL_SERVICE_NAMES = service_list.map { |service| service["name"] }
MAPPED_SERVICE_NAMES = SERVICE_REPOS.map(&:service_name)
missing_service_names = Set.new(ALL_SERVICE_NAMES) - Set.new(MAPPED_SERVICE_NAMES)

unless missing_service_names.empty?
  raise("Missing service profiles: total #{services.length}; Ruby #{RUBY_SERVICE_PROFILES.length}; C# #{CS_SERVICE_PROFILES.length}; Other #{OTHER_SERVICE_PROFILES.length}")
end

helpers do
  def pages_by_category
    SchoolsDigitalTechDocs::PagesByCategory.new(sitemap)
  end

  def service_page_path(service_name)
    SERVICE_PAGE_PATHS.fetch(service_name)
  end

  def service_docs(service_name)
    SERVICE_DOCS.fetch(service_name, [])
  end

  def ruby_service_profiles
    RUBY_SERVICE_PROFILES.reject(&:archived).compact
  end

  def cs_service_profiles
    CS_SERVICE_PROFILES.reject(&:archived).compact
  end

  def other_service_profiles
    OTHER_SERVICE_PROFILES.reject(&:archived).compact
  end

  def archived_service_profiles
    (OTHER_SERVICE_PROFILES + RUBY_SERVICE_PROFILES + CS_SERVICE_PROFILES).select(&:archived).compact
  end
end

services.each do |docset|
  docset.each do |page|
    proxy page.fetch(:path), "templates/external_doc_template.html", page.fetch(:proxy_args)
  end
end

service_list.each do |service|
  proxy SERVICE_PAGE_PATHS.fetch(service["name"]), "templates/service_template.html", locals: {
    profile: SERVICE_PROFILES_BY_NAME.fetch(service["name"]),
    pages: SERVICE_DOCS.fetch(service["name"], []),
  }, data: {
    title: service["name"],
  }
end
