class CreateMunicipalityPrices < ActiveRecord::Migration[7.0]
  def change
    create_table :municipality_prices do |t|
      t.integer :price_cents, null: false, default: 0      
      t.references :municipality, null: false, foreign_key: true
      t.references :package, null: false, foreign_key: true

      t.timestamps
    end
  end
end
