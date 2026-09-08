module SchoolsDigitalTechDocs
  class TitleSort
    def self.key(title)
      match = title.match(/\A\s*(\d+)/)

      [match ? match[1].to_i : Float::INFINITY, title]
    end
  end
end
