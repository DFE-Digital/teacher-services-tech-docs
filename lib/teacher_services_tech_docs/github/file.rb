module SchoolsDigitalTechDocs
  module GitHub
    class File < SimpleDelegator
      def contents
        Base64.decode64(content)
      end
    end
  end
end
