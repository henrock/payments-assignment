# frozen_string_literal: true

class PriceHistory
  def self.call(filter_args)
    filter = {}

    if filter_args[:package]
      filter[:package] = filter_args[:package]
    end

    if filter_args[:year]
      date = DateTime.new(filter_args[:year].to_i)
      filter[:created_at] = date...date.next_year
      puts filter[:created_at]
    end

    if filter_args[:municipality]
      municipality = Municipality.find_by!(name: filter_args[:municipality])
      filter[:municipality_id] = municipality.id
    end

    prices = Price.where(filter)
    price_result = {}

    prices.each do |price|
      if price[:municipality_id]
        municipality = Municipality.find(price[:municipality_id])
        if !price_result[municipality.name]
          price_result[municipality.name] = Array.new
        end
        price_result[municipality.name].push(price.price_cents)
      else
        price_result["base"].push(price.price_cents)
      end
    end

    return price_result
  end
end
