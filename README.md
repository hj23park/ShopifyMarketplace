# README

## USAGE


`GET '/api/product/all'`

This grabs all the products in the database. 

Response:
```
{
    "products": [
        {
            "id": 1,
            "title": "Product #0",
            "price": 30,
            "inventory": 20,
            "created_at": "2019-01-21T04:49:07.820Z",
            "updated_at": "2019-01-21T04:49:07.820Z"
        },
        {
            "id": 2,
            "title": "Product #1",
            "price": 31,
            "inventory": 21,
            "created_at": "2019-01-21T04:49:07.826Z",
            "updated_at": "2019-01-21T04:49:07.826Z"
        },
    ]
}
```
`GET '/api/product/:id'`

This grabs produdct information with a specific id defined on the URL.

Response:
```
{
    "products": {
        "id": 1,
        "title": "Product #0",
        "price": 30,
        "inventory": 20,
        "created_at": "2019-01-21T04:49:07.820Z",
        "updated_at": "2019-01-21T04:49:07.820Z"
    }
}
```
`POST '/api/product/purchase'`

This takes in the id of the product from the user in the HTTP request body and purchases one item of the product with the id. If there is not enough inventory, or the product does not exist, an error message is displayed. This feature is the easiest way to purchase an item quickly.

Response:

```
{
    "message": "Successfully purchased!"
}
```
```
{
    "message": "Error: This product does not exist."
}
```
```
{
    "message": "Error: Do not have enough products on stock."
}
```
`POST '/api/cart/new'`

This creates a new shopping cart for the user and returns a token that is encrypted with the SecureRandom library.

Response:
```
{
    "cart_token": "GWJJrK5mDUa4aQ=="
}
```
`POST '/api/cart/add'`

This takes in the token of the cart, product_id, and desired number of the product and adds to the cart. If the number of the product specified by the user is larger than the inventory, or if the cart or product does not exist, an eror message is displayed. If the cart is adding the product for the first time, this creates a new line in CartItem. If it already exists in the cart, it increases the number of that entry. The inventory is not decreased until it is checked out later. 

Response:
```
{
    "message": "Successfully added to your cart!"
}
```
```
{
    "message": "Error: Not enough inventory for this product."
}
```
```
{
    "message": "Error: This cart does not exist."
}
```
```
{
    "message": "Error: This product does not exist."
}
```
`GET '/api/cart/show/:token'`

This takes in the token of the cart and shows all the items in the cart as well as the total price.

Response:
```
{
    "items": [
        {
            "cart": 2,
            "product": 2,
            "quantity": 10
        },
        {
            "cart": 2,
            "product": 3,
            "quantity": 15
        }
    ],
    "total": 790
}
```
```
{
    "message": "Error: This cart does not exist."
}

```
`POST '/api/cart/delete'`

This takes in token of the cart, product_id, and desired number of product to be deleted, and reduces the number in CartItem. It also displays the product_id and remaining number of the product in the cart after the change. If the number specified by the user is larger than or equal to what the user has in the cart, then the item is deleted from CartItem. It also makes sure that the cart exists and product_id exists in the cart, otherwise, error messages are displayed.

Response:
```
{
    "message": "You have decreased the quantity of the product in your cart.",
    "product": 3,
    "remaining": 14
}
```
```
{
    "message": "This product is deleted from your cart."
}
```
```
{
    "message": "Error: This cart does not exist."
}
```
```
{
    "message": "Error: This product does not exist."
}
```
```
{
    "message": "Error: This product is not in the cart."
}
```

`POST '/api/cart/checkout'`

This takes in token of the shopping cart, checks out the cart and reduces the inventory after making sure that the numbers specified in the shopping cart are all smaller or equal to the inventory for each item. Eror message is displayed if the inventory is not enough to fulfill the request. After reducing the inventory, tt destroys all entries in CartItem however, still the cart is not destroyed so that the user can add more items and purchase again.
Response:
```
{
    "message": "Checked out!"
}
```
```
{
    "message": "Error: This cart does not exist."
}
```
```
{
    "message": "Error: Not enough inventory for this product.",
    "product": 2,
    "inventory": 10 
}
```

## SECURITY FEATURE

