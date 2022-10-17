# frozen_string_literal: true

puts "Removing old packages and their price histories"
Package.destroy_all


puts "Removing old municipalities and their price histories"
Municipality.destroy_all


puts "Creating new municipalities"
Municipality.insert_all(
  YAML.load_file(Rails.root.join("import/municipalities.yaml"))
)


puts "Creating new packages"
Package.insert_all(
  YAML.load_file(Rails.root.join("import/packages.yaml"))
)

premium = Package.find_by!(name: "premium")
plus = Package.find_by!(name: "plus")
basic = Package.find_by!(name: "basic")

puts "Creating municipality prices"
municipality_prices = YAML.load_file(Rails.root.join("import/municipality_prices.yaml"))

municipality_prices.each do |municipality_name, packages|
  municipality = Municipality.find_by!(name: municipality_name)

  packages.each do |package_name, price|
    package = Package.find_by!(name: package_name)
    price["package_id"] = package.id
    municipality.municipality_prices.insert(price)
  end
end

puts "Creating a price history for the packages"
prices = YAML.load_file(Rails.root.join("import/initial_price_history.yaml"))

premium.prices.insert_all(prices["premium"])
plus.prices.insert_all(prices["plus"])
basic.prices.insert_all(prices["basic"])
