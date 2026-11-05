require "capybara/rspec"

RSpec.describe "GOV.UK component rendering" do
  let(:tech_docs) { YAML.load_file("config/tech-docs.yml") }
  let(:renderer) do
    GovukTechDocs::GovukNunjuckComponenetRenderer.new(
      Gem.loaded_specs.fetch("govuk_tech_docs").full_gem_path,
    )
  end
  let(:navigation) do
    tech_docs.fetch("header_links").map do |text, href|
      { href:, text:, active: href == "/" }
    end
  end
  let(:template_data) do
    {
      navigation:,
      serviceUrl: tech_docs.fetch("service_link"),
      serviceName: tech_docs.fetch("service_name"),
      navigationClasses: tech_docs.fetch("navigationContainerClasses", ""),
      classes: tech_docs.fetch("navigationClasses", ""),
    }
  end

  subject(:html) do
    Capybara.string(renderer.render_govuk_component("govukServiceNavigation", template_data))
  end

  it "renders the service navigation through Node and the installed Nunjucks templates" do
    expect(html).to have_css(".govuk-service-navigation[data-module='govuk-service-navigation']")
    expect(html).to have_link(tech_docs.fetch("service_name"), href: tech_docs.fetch("service_link"))

    tech_docs.fetch("header_links").each do |text, href|
      expect(html).to have_link(text, href:)
    end

    expect(html).to have_css(".govuk-service-navigation__item--active a[href='/']")
  end
end
