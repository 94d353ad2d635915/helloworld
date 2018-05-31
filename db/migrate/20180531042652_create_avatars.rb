class CreateAvatars < ActiveRecord::Migration[5.2]
  def up
    create_table :avatars do |t|
      t.string :url
      t.references :avatarable, polymorphic: true, index: true
    end
  end

  def down
    drop_table :avatars
  end
end
