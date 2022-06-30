require "capybara/rspec"

RSpec.describe TeacherServicesTechDocs::GitHub::MarkdownFile do
  let(:name) { "my_file.md" }
  let(:path) { "docs/my_file.md" }
  let(:contents) { "" }
  subject(:markdown_file) { described_class.new(name:, path:, contents:) }

  describe "#to_html" do
    subject { markdown_file.to_html }

    context "basic html" do
      let(:contents) do
        <<~MD
          # Title
          [link](#anchor)
        MD
      end

      it { is_expected.to eq("\n<p><a href=\"#anchor\">link</a></p>") }
    end

    context "with non-UTF-8 content" do
      let(:contents) do
        String.new(
          "These curly quotes “make commonmarker throw an exception”",
          encoding: "ASCII-8BIT",
        )
      end

      it { is_expected.to eq("<p>These curly quotes “make commonmarker throw an exception”</p>") }
    end

    context "when passed a repo name and branch" do
      let(:path) { "markdown.md" }
      let(:contents) do
        File.read("spec/fixtures/markdown.md")
      end

      subject(:html) do
        Capybara.string(
          markdown_file.to_html(repo_name: "alphagov/lipsum", branch: "master"),
        )
      end

      it "removes the title of the page" do
        expect(html).not_to have_selector("h1", text: "Lorem ipsum")
      end

      it "does not rewrite links to markdown pages with a host" do
        expect(html).to have_link("Absolute link", href: "https://nam.com/eget/dui/absolute-link.md")
      end

      it "converts relative links to absolute GitHub URLs" do
        expect(html).to have_link("inline link", href: "https://github.com/alphagov/lipsum/blob/master/inline-link.md")
      end

      it "converts aliased links to absolute GitHub URLs" do
        expect(html).to have_link("aliased link", href: "https://github.com/alphagov/lipsum/blob/master/lib/aliased_link.rb")
      end

      it "rewrites relative images" do
        expect(html).to have_css('img[src="https://raw.githubusercontent.com/alphagov/lipsum/master/suspendisse_iaculis.png"]')
      end

      it "treats URLs containing non-default ports as absolute URLs" do
        expect(html).to have_link("localhost", href: "localhost:999")
      end

      it "maintains anchor links" do
        expect(html).to have_link("Suspendisse iaculis", href: "#suspendisse-iaculis")
      end

      it "adds an id attribute to all headers so they can be accessed from a table of contents" do
        expect(html).to have_selector("h2#tldr")
      end

      it "converts heading IDs properly" do
        expect(html).to have_selector("h3#data-gov-uk")
        expect(html).to have_selector("h3#patterns-style-guides")
      end
    end
  end

  describe "#title" do
    subject { markdown_file.title }

    context "when the title is present" do
      let(:contents) do
        <<~MD
          #Title
          [link](#anchor)
        MD
      end

      it { is_expected.to eq("Title") }
    end

    context "when the title has extra spaces" do
      let(:contents) do
        <<~MD
          #    Title
          [link](#anchor)
        MD
      end

      it { is_expected.to eq("Title") }
    end

    context "when there is no title" do
      let(:contents) { "" }
      let(:name) { "my_documentation_file.md" }

      it { is_expected.to eq("my_documentation_file") }
    end
  end
end
