require_relative "lib/teacher_services_tech_docs"

GovukTechDocs.configure(self)

service_list = YAML.load_file("config/services.yml")

services = service_list.reduce([]) do |list, service|
  repo = TeacherServicesTechDocs::GitHub::RubyRepo.new(
    repo_name: service["repo_name"],
    service_name: service["name"],
  )

  list + service["docsets"].map do |docset|
    repo.load_docs(
      path_in_repo: docset["path"],
      ignore_files: docset.fetch("ignore_files", []),
    )
  end
end

ignore "templates/*"

RUBY_SERVICE_REPOS = service_list.select { |s| s["language"] == "ruby" }.map do |service|
  repo = TeacherServicesTechDocs::GitHub::RubyRepo.new(
    repo_name: service["repo_name"],
    service_name: service["name"],
  )

  raise "No profile created for #{service}" unless repo.profile

  repo
end

RUBY_SERVICE_PROFILES = RUBY_SERVICE_REPOS.map { |repo| repo.profile }


CS_SERVICE_REPOS = service_list.select { |s| s["language"] == "cs" }.map do |service|
  repo = TeacherServicesTechDocs::GitHub::CsRepo.new(
    repo_name: service["repo_name"],
    csproj_path: service["csproj_path"],
    service_name: service["name"],
  )

  raise "No profile created for #{service} " unless repo.profile

  repo
end

CS_SERVICE_PROFILES = CS_SERVICE_REPOS.map { |repo|  repo.profile }

ALL_SERVICE_NAMES = service_list.map do |service|
  service["name"]
end

MAPPED_SERVICE_NAMES = (CS_SERVICE_REPOS + RUBY_SERVICE_REPOS).map do |repo|
  repo.service_name
end

OTHER_SERVICE_NAMES = service_list.select {|r| r["language"] == 'other'}.map do |service|
  service["name"]
end

missing_service_names = Set.new(ALL_SERVICE_NAMES) - Set.new(MAPPED_SERVICE_NAMES + OTHER_SERVICE_NAMES)


if missing_service_names.length > 0

  raise("Missing service profiles: total #{services.length}; Ruby #{RUBY_SERVICE_PROFILES.length}; C# #{CS_SERVICE_PROFILES.length}; Other #{OTHER_SERVICE_NAMES.length}")
end

helpers do
  def pages_by_category
    TeacherServicesTechDocs::PagesByCategory.new(sitemap)
  end

  def ruby_service_profiles
    RUBY_SERVICE_PROFILES.compact
  end

  def cs_service_profiles
    CS_SERVICE_PROFILES.compact
  end
end

services.each do |docset|
  docset.each do |page|
    proxy page.fetch(:path), "templates/external_doc_template.html", page.fetch(:proxy_args)
  end
end
