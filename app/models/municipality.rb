class Municipality < ApplicationRecord
  has_many :municipality_prices, dependent: :destroy
  
  validates :name, presence: true, uniqueness: true
end
