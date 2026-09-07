require_relative "lib/teacher_services_tech_docs"

GovukTechDocs.configure(self)

service_list = YAML.load_file("config/services.yml")

service_page_slug = lambda do |service_name|
  service_name.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/^-|-$/, "")
end

service_docs = Hash.new { |hash, key| hash[key] = [] }

services = service_list.reduce([]) do |list, service|
  repo = SchoolsDigitalTechDocs::GitHub::RubyRepo.new(
    repo_name: service["repo_name"],
    service_name: service["name"],
  )

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

RUBY_SERVICE_REPOS = service_list.select { |s| s["language"] == "ruby" }.map do |service|
  repo = SchoolsDigitalTechDocs::GitHub::RubyRepo.new(
    repo_name: service["repo_name"],
    service_name: service["name"],
  )

  raise "No profile created for #{service}" unless repo.profile

  repo
end

CS_SERVICE_REPOS = service_list.select { |s| s["language"] == "cs" }.map do |service|
  repo = SchoolsDigitalTechDocs::GitHub::CsRepo.new(
    repo_name: service["repo_name"],
    csproj_path: service["csproj_path"],
    service_name: service["name"],
  )

  raise "No profile created for #{service} " unless repo.profile

  repo
end

OTHER_SERVICE_REPOS = service_list.select { |s| s["language"] == "other" }.map do |service|
  repo = SchoolsDigitalTechDocs::GitHub::OtherRepo.new(
    repo_name: service["repo_name"],
    service_name: service["name"],
  )

  raise "No profile created for #{service} " unless repo.profile

  repo
end

CS_SERVICE_PROFILES = CS_SERVICE_REPOS.sort_by(&:service_name).map(&:profile)
RUBY_SERVICE_PROFILES = RUBY_SERVICE_REPOS.sort_by(&:service_name).map(&:profile)
OTHER_SERVICE_PROFILES = OTHER_SERVICE_REPOS.sort_by(&:service_name).map(&:profile)
RUBY_SERVICE_PROFILES_BY_NAME = RUBY_SERVICE_PROFILES.to_h { |profile| [profile.service_name, profile] }.freeze
SERVICE_DOCS = service_docs.freeze
SERVICE_PAGE_PATHS = service_list.to_h { |service| [service["name"], "/service/#{service_page_slug.call(service["name"])}.html"] }.freeze

ALL_SERVICE_NAMES = service_list.map do |service|
  service["name"]
end

MAPPED_SERVICE_NAMES = (CS_SERVICE_REPOS + RUBY_SERVICE_REPOS).map(&:service_name)

OTHER_SERVICE_NAMES = service_list.select { |r| r["language"] == "other" }.map do |service|
  service["name"]
end

missing_service_names = Set.new(ALL_SERVICE_NAMES) - Set.new(MAPPED_SERVICE_NAMES + OTHER_SERVICE_NAMES)

unless missing_service_names.empty?
  raise("Missing service profiles: total #{services.length}; Ruby #{RUBY_SERVICE_PROFILES.length}; C# #{CS_SERVICE_PROFILES.length}; Other #{OTHER_SERVICE_NAMES.length}")
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
    service_name: service["name"],
    repo_name: service["repo_name"],
    pages: SERVICE_DOCS.fetch(service["name"], []),
    ruby_service_profile: RUBY_SERVICE_PROFILES_BY_NAME[service["name"]],
  }, data: {
    title: service["name"],
  }
end
