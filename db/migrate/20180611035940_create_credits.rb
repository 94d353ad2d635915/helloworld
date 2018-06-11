class CreateCredits < ActiveRecord::Migration[5.2]
  def change
    create_table :credits do |t|
      t.references :user, foreign_key: true
      t.string :currency, null: false
      t.integer :balance, null: false, default: 0

      t.timestamps
    end
  end
end
