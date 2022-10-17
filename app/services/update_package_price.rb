# frozen_string_literal: true

class UpdatePackagePrice
  def self.call(package, new_price_cents, **options)    
    Package.transaction do
      if options[:municipality]   
        #Find the passed municipality
        municipality_name = options[:municipality]
        municipality = Municipality.find_by!(name: municipality_name)
        municipality_price = MunicipalityPrice.find_or_create_by(package: package, municipality_id: municipality.id)

        # Add a pricing history record
        Price.create!(package: package, price_cents: municipality_price.price_cents, municipality: municipality)

        # Update the current price
        municipality_price.update!(price_cents: new_price_cents)
      else
        # Add a pricing history record
        Price.create!(package: package, price_cents: package.price_cents)

        # Update the current price
        package.update!(price_cents: new_price_cents)
      end
    end
  end
end
