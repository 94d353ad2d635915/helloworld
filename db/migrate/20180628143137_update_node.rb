class UpdateNode < ActiveRecord::Migration[5.2]
  def up
    change_table :nodes do |t|
      t.column :css, :string
      t.column :body, :string
    end
    change_column(:posttexts, :textable_type, :integer)
  end

  def down
    change_table :nodes do |t|
      t.remove :css
      t.remove :body
    end
    change_column(:posttexts, :textable_type, :string)
  end
end