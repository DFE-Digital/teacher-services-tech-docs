require_relative "lib/teacher_services_tech_docs"

GovukTechDocs.configure(self)

service_list = YAML.load_file("config/services.yml")

services = service_list.reduce([]) do |list, service|
  repo = TeacherServicesTechDocs::GitHub::Repo.new(
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

SERVICE_PROFILES = service_list.map do |service|
  repo = TeacherServicesTechDocs::GitHub::Repo.new(
    repo_name: service["repo_name"],
    service_name: service["name"],
  )

  repo.profile
end

helpers do
  def pages_by_category
    TeacherServicesTechDocs::PagesByCategory.new(sitemap)
  end

  def service_profiles
    SERVICE_PROFILES.compact
  end
end

services.each do |docset|
  docset.each do |page|
    proxy page.fetch(:path), "templates/external_doc_template.html", page.fetch(:proxy_args)
  end
end
