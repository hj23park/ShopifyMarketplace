class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :title
      t.float :price
      t.integer :inventory

      t.timestamps
    end
  end
end
