class CartController < ApplicationController
	skip_before_action :verify_authenticity_token

	def create
		new_cart = Cart.create_new

		render status: 200, json: {
			cart_token: new_cart.token
		}.to_json
	end

	def show_items
		cart = Cart.find_by(token: params[:token])

		if cart
			# calculate the total dollar amount
			total = cart.get_total_dollar_amount
			render status: 200, json: {
				items: cart.cart_items.map{|c| {
					cart: c.cart_id, 
					product: c.product_id, 
					quantity: c.quantity
				}},
				total: total,
			}.to_json
		else 
			render status: 400, json: {
				message: "Error: This cart does not exist.",
			}.to_json
		end
	end
	
	# Adds one item at a time to the cart
	def add_item
		req_body = JSON.parse(request.body.read)
		token = req_body["token"]
		product_id = req_body["product_id"]
		count = req_body["count"]

		cart = Cart.find_by(token: token)
		product = Product.find_by(id: product_id)

		if !cart
			render status: 400, json: {
				message: "Error: This cart does not exist.",
			}.to_json
			return
		end
		
		if !product
			render status: 400, json: {
				message: "Error: This product does not exist.",
			}.to_json
			return
		end

		# one entry in CartItem for each product in a cart 
		one_cart_item = cart.cart_items.where(product: product)[0]
		potential_cart_count = count + (one_cart_item ? one_cart_item.quantity : 0)
		
		if potential_cart_count > product.inventory
			render status: 400, json: {
				message: "Error: Not enough inventory for this product.",
			}.to_json
			return
		end

		if one_cart_item && count + one_cart_item.quantity <= product.inventory
			one_cart_item.quantity = one_cart_item.quantity + count			
			one_cart_item.save
			render status: 200, json: {
				message: "Successfully added to your cart!",
			}.to_json
		elsif !one_cart_item && count <= product.inventory
			new_item = CartItem.new
			new_item.cart = cart
			new_item.product = product
			new_item.quantity = count 
			new_item.save
			render status: 200, json: {
				message: "Successfully added to your cart!",
			}.to_json
		end
	end

	# Removes one product at a time
	def delete_item
		req_body = JSON.parse(request.body.read)
		token = req_body["token"]
		product_id = req_body["product_id"]
		count = req_body["count"]

		cart = Cart.find_by(token: token)
		product = Product.find_by(id: product_id)
		one_cart_item = cart.cart_items.where(product: product)[0]

		if !cart
			render status: 400, json: {
				message: "Error: This cart does not exist.",
			}.to_json
			return
		end
		
		if !product
			render status: 400, json: {
				message: "Error: This product does not exist.",
			}.to_json
			return
		end

		if !one_cart_item
			render status: 400, json: {
				message: "Error: This product is not in the cart.",
			}.to_json
			return
		end

		if count >= one_cart_item.quantity
			# delete cart
			one_cart_item.destroy
			render status: 200, json: {
				message: "This product is deleted from your cart.",
			}.to_json
		else
			# edit cart
			one_cart_item.quantity = one_cart_item.quantity - count
			one_cart_item.save
			render status: 200, json: {
				message: "You have decreased the quantity of the product in your cart.",
				product: one_cart_item.product_id,
				remaining: one_cart_item.quantity,
			}.to_json 
		end
	end

	def checkout 
		req_body = JSON.parse(request.body.read)
		token = req_body["token"]
		cart = Cart.find_by(token: token)

		if !cart 
			render status: 400, json: {
				message: "Error: This cart does not exist.",
			}.to_json
			return
		end

		items = cart.cart_items
		# check that all items are available in the inventory
		items.each do |item|
			product = item.product
			# inventory = product.inventory 
			if item.quantity > product.inventory
				render status: 404, json: {
					message: "Error: Not enough inventory for this product.",
					product: item.id,
					inventory: product.inventory,
				}.to_json
				return
			end				
		end

		# check out the items and make changes to the inventory
		items.each do |item|
			product = item.product
			product.inventory = product.inventory - item.quantity
			product.save
			# item.destroy
		end

		render status: 200, json: {
			message: "Checked out!",
		}.to_json

		# destroy entries in CartItem
		items.each do |item|
			item.destroy
		end
	end 
end
