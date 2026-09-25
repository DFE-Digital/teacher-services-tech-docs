require "spec_helper"

RSpec.describe SchoolsDigitalTechDocs::TitleSort do
  it "orders numbered titles numerically rather than alphabetically" do
    titles = ["10. Deployment", "2. Architecture", "1. Getting started"]

    expect(titles.sort_by { |title| described_class.key(title) }).to eq(
      ["1. Getting started", "2. Architecture", "10. Deployment"],
    )
  end

  it "sorts unnumbered titles alphabetically after all numbered titles" do
    titles = ["Troubleshooting", "2. Architecture", "FAQ", "1. Getting started"]

    expect(titles.sort_by { |title| described_class.key(title) }).to eq(
      ["1. Getting started", "2. Architecture", "FAQ", "Troubleshooting"],
    )
  end

  it "falls back to alphabetical order when no titles are numbered" do
    titles = %w[Zebra Apple Mango]

    expect(titles.sort_by { |title| described_class.key(title) }).to eq(
      %w[Apple Mango Zebra],
    )
  end

  it "handles numbers not immediately followed by a period" do
    titles = ["10 - Deployment", "2) Architecture", "1: Getting started"]

    expect(titles.sort_by { |title| described_class.key(title) }).to eq(
      ["1: Getting started", "2) Architecture", "10 - Deployment"],
    )
  end
end
