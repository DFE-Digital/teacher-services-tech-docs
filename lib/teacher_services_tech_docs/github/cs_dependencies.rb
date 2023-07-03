module TeacherServicesTechDocs
  module GitHub
    class CsDependencies
      def initialize(csproj_contents)
        @parsed_csproj = Nokogiri::XML(csproj_contents)
      end

      def target_framework
        node = @parsed_csproj.xpath("//PropertyGroup/TargetFramework")
        node.text
      end

      def dfe_analytics_version
        find_version("Dfe.Analytics.AspNetCore")
      end

    private

      def find_version(package_name)
        node = @parsed_csproj.xpath("//PackageReference[@Include='#{package_name}']")
        node.attribute("Version")&.value
      end
    end
  end
end
