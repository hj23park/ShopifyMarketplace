class ProductController < ApplicationController
	skip_before_action :verify_authenticity_token
	
	def show
		product = Product.find_by(id: params[:id])
		if product
			render status: 200, json: {
				products: product
			}.to_json
		else
			render status: 400, json: {
				message: "Error: This product does not exist.",
			}.to_json
		end
	end

	def show_all
		product = Product.all
		
		render status: 200, json: {
			products: product
		}.to_json
	end

	def purchase
		req_body = JSON.parse(request.body.read)
		id = req_body["id"]
		count = req_body["count"]
		
		product = Product.find_by(id: id)

		if product && count <= product.inventory
			product.inventory = product.inventory - count
			product.save
			render status: 200, json: {
				message: "Successfully purchased!",
			}.to_json
		elsif !product
			render status: 400, json: {
				message: "Error: This product does not exist.",
			}.to_json			
		elsif count > product.inventory
			render status: 401, json: {
				message: "Error: Do not have enough products on stock.",
			}.to_json
		end
	end
end
