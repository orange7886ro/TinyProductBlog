class UserProfile < ActiveRecord::Migration
  def change
    create_table(:profiles) do |t|
      t.string  :name,                      null: false, default: ""
      t.integer :user_id
      t.string  :image

      t.datetime :created_at
    end

    add_index :profiles, :user_id
  end
end
