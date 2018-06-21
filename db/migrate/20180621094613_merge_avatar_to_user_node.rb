class MergeAvatarToUserNode < ActiveRecord::Migration[5.2]
  def up
    drop_table :avatars

    add_column :profiles, :avatar, :string
    add_column :nodes, :avatar, :string
  end

  def down
    remove_column :nodes, :avatar
    remove_column :profiles, :avatar

    create_table :avatars do |t|
      t.string :url
      t.references :avatarable, polymorphic: true, index: true
    end
  end
end
