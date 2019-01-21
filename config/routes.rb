Rails.application.routes.draw do
  get '/api/product/all', to: 'product#show_all'
  get '/api/product/:id', to: 'product#show'
  post '/api/product/purchase', to: 'product#purchase'

  get '/api/cart/show/:id', to: 'cart#show_items'
  post '/api/cart/new', to: 'cart#create'
  post '/api/cart/add', to: 'cart#add_item'
  post '/api/cart/delete', to: 'cart#delete_item'
  post '/api/cart/checkout', to: 'cart#checkout'
end
