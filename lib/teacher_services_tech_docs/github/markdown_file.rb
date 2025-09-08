module SchoolsDigitalTechDocs
  module GitHub
    class MarkdownFile
      def initialize(name:, path:, contents:)
        @name = name
        @path = path
        @contents = contents
      end

      def to_html(repo_name: "", branch: "")
        context = {
          repository: repo_name,
          # Turn off hardbreaks as they behave different to github rendering
          gfm: false,
          base_url: URI.join(
            "https://github.com",
            "#{repo_name}/blob/#{branch}/",
          ),
          image_base_url: URI.join(
            "https://raw.githubusercontent.com",
            "#{repo_name}/#{branch}/",
          ),
        }

        context[:subpage_url] =
          URI.join(context[:base_url], ::File.join(".", ::File.dirname(@path), "/"))

        context[:image_subpage_url] =
          URI.join(context[:image_base_url], ::File.join(".", ::File.dirname(@path), "/"))

        filters = [
          HTML::Pipeline::MarkdownFilter,
          HTML::Pipeline::AbsoluteSourceFilter,
          PrimaryHeadingFilter,
          HeadingFilter,
          AbsoluteLinkFilter,
        ]

        HTML::Pipeline
          .new(filters)
          .to_html(@contents.to_s.force_encoding("UTF-8"), context)
      end

      def title
        markdown_title = @contents.split("\n")[0].to_s.match(/#(.+)/)

        return filename unless markdown_title

        markdown_title[1].strip
      end

      def filename
        @name.match(/(.+)\..+$/)[1]
      end

      # When we import external documentation it can contain relative links to
      # source files within the repository that the documentation resides. We need
      # to filter out these types of links and make them absolute so that they
      # continue to work when rendered as part of these docs.
      #
      # For example a link to `lib/link_expansion.rb` would be rewritten to
      # https://github.com/{org}/{repo}/blob/master/lib/link_expansion.rb
      class AbsoluteLinkFilter < HTML::Pipeline::Filter
        def call
          doc.search("a").each do |element|
            next if element["href"].nil? || element["href"].empty?

            href = element["href"].strip
            uri = URI.parse(href)
            path = uri.path

            next if uri.scheme || href.start_with?("#")

            base = if path.start_with? "/"
                     base_url
                   else
                     context[:subpage_url]
                   end

            element["href"] = URI.join(base, href).to_s
          end

          doc
        end
      end

      # Removes the H1 from the page so that we can choose our own title
      class PrimaryHeadingFilter < HTML::Pipeline::Filter
        def call
          h1 = doc.at("h1:first-of-type")
          h1.unlink if h1.present?
          doc
        end
      end

      # This adds a unique ID to each header element so that we can reference
      # each section of the document when we build our table of contents navigation.
      class HeadingFilter < HTML::Pipeline::Filter
        def call
          headers = Hash.new(0)

          doc.css("h1, h2, h3, h4, h5, h6").each do |node|
            text = node.text
            id = string_to_id(text)

            headers[id] += 1

            if node.children.first
              node[:id] = id
            end
          end

          doc
        end

      private

        def string_to_id(string)
          string
            .downcase # lower case
            .gsub(/<[^>]*>/, "") # crudely remove html tags
            .gsub(/[^\w\-. ]/, "") # remove any non-word, non-hyphen & non-period characters
            .gsub(/[ .]/, "-") # replace spaces & periods with hyphens
            .gsub(/-{2,}/, "-") # replace two (or more) subsequent hyphens with single hyphens
        end
      end
    end
  end
end
