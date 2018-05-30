class CreateComments < ActiveRecord::Migration[5.2]
  def up
    create_table :comments do |t|
      t.references :posttext, foreign_key: true
      t.references :user, foreign_key: true
      t.references :topic, foreign_key: true

      t.timestamps
    end
  end
  def down
    drop_table :comments
  end
end
