class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title, null: false, default: ""
      t.text :description, null: false, default: ""
      t.boolean :is_public, null: false, default: true
      t.string :image, null: false, default: ""
      t.integer :product_id
      t.integer :vote_count, null: false, default: 0
      t.integer :user_id
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps null: false
    end
  end
end
