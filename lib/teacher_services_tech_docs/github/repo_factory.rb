module SchoolsDigitalTechDocs
  module GitHub
    class RepoFactory
      def self.build(service:, client: GitHub::Client.new)
        common_args = {
          repo_name: service.fetch("repo_name"),
          service_name: service.fetch("name"),
          client:,
        }

        case service.fetch("language")
        when "ruby"
          RubyRepo.new(**common_args)
        when "cs"
          CsRepo.new(**common_args, csproj_path: service.fetch("csproj_path"))
        when "other"
          OtherRepo.new(**common_args, language: service.fetch("language"))
        else
          raise "Unsupported language '#{service['language']}' for #{service['name']}"
        end
      end
    end
  end
end
