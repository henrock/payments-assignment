class AddMunicipalityReferenceToPrices < ActiveRecord::Migration[7.0]
  def change
    add_reference :prices, :municipality
  end
end
