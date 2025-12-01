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

RUBY_SERVICE_PROFILES = service_list.select { |s| s["language"] == "ruby" }.map do |service|
  repo = TeacherServicesTechDocs::GitHub::RubyRepo.new(
    repo_name: service["repo_name"],
    service_name: service["name"],
  )

  repo.profile
end

CS_SERVICE_PROFILES = service_list.select { |s| s["language"] == "cs" }.map do |service|
  repo = TeacherServicesTechDocs::GitHub::CsRepo.new(
    repo_name: service["repo_name"],
    csproj_path: service["csproj_path"],
    service_name: service["name"],
  )

  repo.profile
end

if RUBY_SERVICE_PROFILES.length + CS_SERVICE_PROFILES.length != services.length
  raise("Missing service profiles: total #{services.length}; Ruby #{RUBY_SERVICE_PROFILES.length}; C# #{CS_SERVICE_PROFILES.length}")
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
