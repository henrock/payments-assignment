# frozen_string_literal: true

require "spec_helper"

RSpec.describe PriceHistory do
  # These tests cover feature request 2. Feel free to add more tests or change
  # the existing ones.

  it "returns the pricing history for the provided year and package" do
    basic = Package.create!(name: "basic")
    stockholm = Municipality.create!(name: "Stockholm")
    goteborg = Municipality.create!(name: "Göteborg")

    travel_to Time.zone.local(2019) do
      # These should NOT be included
      UpdatePackagePrice.call(basic, 20_00, municipality: "Stockholm")
      UpdatePackagePrice.call(basic, 30_00, municipality: "Göteborg")
    end

    # Had to move these putside the travel_to block since the price is added to history when it is overwritten, not when it is set
    UpdatePackagePrice.call(basic, 30_00, municipality: "Stockholm")
    UpdatePackagePrice.call(basic, 100_00, municipality: "Göteborg")
    travel_to Time.zone.local(2020) do
      UpdatePackagePrice.call(basic, 40_00, municipality: "Stockholm")
      #Update back to new prices to push the "current" ones into the history
      UpdatePackagePrice.call(basic, 200_00, municipality: "Stockholm")
      UpdatePackagePrice.call(basic, 199_00, municipality: "Göteborg")
    end
    

    history = PriceHistory.call(package: basic, year: "2020")
    expect(history).to eq(
      "Göteborg" => [100_00],
      "Stockholm" => [30_00, 40_00],
    )
  end

  it "supports filtering on municipality" do
    basic = Package.create!(name: "basic")
    stockholm = Municipality.create!(name: "Stockholm")
    goteborg = Municipality.create!(name: "Göteborg")

    # Had to move these putside the travel_to block since the price is added to history when it is overwritten, not when it is set
    UpdatePackagePrice.call(basic, 30_00, municipality: "Stockholm")
    UpdatePackagePrice.call(basic, 100_00, municipality: "Göteborg")
    travel_to Time.zone.local(2020) do
      UpdatePackagePrice.call(basic, 40_00, municipality: "Stockholm")
      #Update back to new prices to push the "current" ones into the history
      UpdatePackagePrice.call(basic, 200_00, municipality: "Stockholm")
      UpdatePackagePrice.call(basic, 199_00, municipality: "Göteborg")
    end

    # Whoops no assertions, please add some
    stockholm_history = PriceHistory.call(package: basic, year: "2020", municipality: "Stockholm")
    expect(stockholm_history).to eq(
      "Stockholm" => [30_00, 40_00],
    )
    goteborg_history = PriceHistory.call(package: basic, year: "2020", municipality: "Göteborg")
    expect(goteborg_history).to eq(
      "Göteborg" => [100_00],
    )
  end
end
