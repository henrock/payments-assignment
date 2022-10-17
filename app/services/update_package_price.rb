# frozen_string_literal: true

class UpdatePackagePrice
  def self.call(package, new_price_cents, **options)    
    Package.transaction do
      if options[:municipality]   
        #Find the passed municipality
        municipality_name = options[:municipality]
        municipality = Municipality.find_by!(name: municipality_name)

        # Add a pricing history record
        Price.create!(package: package, price_cents: package.price_cents, municipality_id: municipality.id)

        # Update the current price
        municipality_price = MunicipalityPrice.find_by(package_id: package.id, municipality_id: municipality.id)
        if (municipality_price == nil)
          MunicipalityPrice.create(package_id: package.id, municipality_id: municipality.id, price_cents: new_price_cents)
        else
          municipality_price.update!(price_cents: new_price_cents)
        end
      else
        # Add a pricing history record
        Price.create!(package: package, price_cents: package.price_cents)

        # Update the current price
        package.update!(price_cents: new_price_cents)
      end
    end
  end
end
