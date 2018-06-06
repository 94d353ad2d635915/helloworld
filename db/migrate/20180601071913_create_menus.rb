class CreateMenus < ActiveRecord::Migration[5.2]
  def change
    create_table :menus do |t|
      t.references :menu, foreign_key: true
      t.float :priority, default: 1024
      t.string :name
      t.references :permission, foreign_key: true
      t.string :description
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
