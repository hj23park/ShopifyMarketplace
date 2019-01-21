class AddTokenToCarts < ActiveRecord::Migration[5.2]
  def change
    add_column :carts, :token, :string
  end
end
