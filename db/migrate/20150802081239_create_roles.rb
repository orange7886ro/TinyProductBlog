class CreateRoles < ActiveRecord::Migration
  def change
    create_table(:roles) do |t|
      t.string  :name,                      null: false, default: ""
      t.integer :users_count,               null: false, default: 0

      t.datetime :created_at
      t.datetime :updated_at
    end

    add_column :users, :role_id,            :integer, default: 0
  end

  def migrate(direction)
    super
    # migrate時に初期管理ユーザにsuper_admin権限を付与
    # blog_admin@takobearnet.com/password
    admin_role = Role.create!(
      name: 'SuperAdmin'
    ) if direction == :up
    Role.create!(
      name: 'ProductAdmin'
    ) if direction == :up
    Role.create!(
      name: 'RegisteredUser'
    ) if direction == :up
    admin_role.users.create!(
      email: 'blog_admin@takobearnet.com',
      password: 'password'
    ) if direction == :up
  end
end
