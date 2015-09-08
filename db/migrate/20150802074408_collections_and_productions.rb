class CollectionsAndProductions < ActiveRecord::Migration
  def change
    create_table(:collections) do |t|
      t.string  :title,                      null: false, default: ""
      t.integer :products_count,          null: false, default: 0

      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table(:collection_items) do |t|
      t.integer :collection_id,              null: false, default: 0
      t.integer :product_id,              null: false, default: 0

      t.datetime :created_at
      t.datetime :updated_at
    end

    add_index :collection_items, :collection_id
    add_index :collection_items, :product_id

    create_table(:products) do |t|
      t.string  :title,                      null: false, default: ""
      t.integer :collections_count,          null: false, default: 0
      t.integer :user_id

      t.datetime :created_at
      t.datetime :updated_at
    end

    add_index :products, :user_id

    add_column :users, :products_count, :integer, default: 0
  end
end
