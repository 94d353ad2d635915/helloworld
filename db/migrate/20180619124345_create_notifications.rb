class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.belongs_to :user
      t.integer :sender_id
      t.integer :_type, null: false
      t.references :notifiable, polymorphic: true, index: false
      t.references :second_notifiable, polymorphic: true, index: false
      t.references :third_notifiable, polymorphic: true, index: false

      t.datetime :created_at
    end
  end
end
