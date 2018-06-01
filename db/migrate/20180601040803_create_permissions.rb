class CreatePermissions < ActiveRecord::Migration[5.2]
  def change
    create_table :permissions do |t|
      t.integer :priority
      t.string :name
      t.string :alias
      t.string :verb
      t.string :path
      t.string :controller
      t.string :action
      t.string :params_permit
      t.string :params_range

      t.timestamps
    end
  end
end
