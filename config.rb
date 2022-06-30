require_relative "lib/teacher_services_tech_docs"

GovukTechDocs.configure(self)

services = YAML.load_file("config/services.yml")

services = services.reduce([]) do |list, service|
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

helpers do
  def pages_by_category
    TeacherServicesTechDocs::PagesByCategory.new(sitemap)
  end
end

services.each do |docset|
  docset.each do |page|
    proxy page.fetch(:path), "templates/external_doc_template.html", page.fetch(:proxy_args)
  end
end
