class CreateOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :options do |t|
      t.string :name, null: false, default: '', index: true, uniq: true
      t.text :value, null: false, default: nil
      t.string :description, null: false, default: ''
      t.integer :autoload, null: false, default: 1
    end
  end
end
