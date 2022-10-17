# frozen_string_literal: true

class Package < ApplicationRecord
  has_many :prices, dependent: :destroy
  has_many :municipality_prices, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :price_cents, presence: true

  def price_for(municipality_name)    
    municipality = Municipality.find_by!(name: municipality_name)
    price = MunicipalityPrice.find_by!(municipality_id: municipality.id, package_id: self.id)
    return price.price_cents
  end
end
