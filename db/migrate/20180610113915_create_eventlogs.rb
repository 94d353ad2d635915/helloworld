class CreateEventlogs < ActiveRecord::Migration[5.2]
  def change
    create_table :eventlogs do |t|
      t.datetime :created_at
      t.string :ip
      t.string :user_agent
      t.references :user, foreign_key: true
      t.references :event, foreign_key: true
      t.string :description
    end
  end
end
