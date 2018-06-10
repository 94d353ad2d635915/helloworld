class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.references :permission, foreign_key: true
      t.string :description

      t.timestamps
    end
  end
end
