class Cart < ApplicationRecord
	has_many :cart_items
	has_many :products, :through => :cart_items

	def get_total_dollar_amount
		total = 0
		cart_items.each do |cart_item|
			total = total + (cart_item.quantity * cart_item.product.price)
		end
		return total.round(2)
	end
end
