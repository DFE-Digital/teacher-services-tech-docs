module SchoolsDigitalTechDocs
  class TitleSort
    def self.key(title)
      leading_number = title[/\A\s*\d+/]

      return [Float::INFINITY, title] unless leading_number

      [leading_number.to_i, title]
    end
  end
end
