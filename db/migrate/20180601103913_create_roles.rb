class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.references :role, foreign_key: true
      t.string :name
      t.string :description
      t.references :user, foreign_key: true

      t.timestamps
    end
    # permissions_roles
    create_table :assign_permissions_roles do |t|
      t.belongs_to :role, index: true
      t.belongs_to :permission, index: true
      # extra attributes
      t.integer :assignee_id
      t.timestamps
    end
    add_index :assign_permissions_roles, :assignee_id
    # rails g model assign_permissions_role --no-migration

    # roles_users
    # Assignment
    create_table :assign_roles_users do |t|
      t.belongs_to :role, index: true
      t.belongs_to :user, index: true
      # extra attributes
      t.integer :assignee_id
      t.timestamps
    end
    add_index :assign_roles_users, :assignee_id
    # rails g model assign_roles_user --no-migration
  end
end
