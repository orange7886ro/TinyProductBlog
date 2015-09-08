class RemoveUniqueToProducts < ActiveRecord::Migration
  def change
    remove_index :products, :user_id
  end
end
