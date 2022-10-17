class MunicipalityPrice < ApplicationRecord  
  belongs_to :municipality, optional: false  
  belongs_to :package, optional: false  
  
  validates :price_cents, presence: true, uniqueness: false
  validates :municipality_id, presence: true, uniqueness: { scope: :package_id }
end
