class AddMoreFieldToProducts < ActiveRecord::Migration
  def change
    add_column :products, :description, :string
    add_column :products, :image, :string
  end
end
