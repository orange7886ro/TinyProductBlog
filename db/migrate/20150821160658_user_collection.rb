class UserCollection < ActiveRecord::Migration
  def change
    remove_column :products, :collections_count
    add_column    :users, :collections_count, :integer, default: 0
    add_column    :collections, :user_id, :integer, default: 0
    add_column    :products, :collections_count, :integer, default: 0
  end
end
