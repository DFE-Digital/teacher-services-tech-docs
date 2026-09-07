module SchoolsDigitalTechDocs
  module GitHub
    class File < SimpleDelegator
      def contents
        Base64.decode64(content).dup.force_encoding("UTF-8")
      end
    end
  end
end
