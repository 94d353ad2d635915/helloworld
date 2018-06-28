class UpdateCreditOperation < ActiveRecord::Migration[5.2]
  def up
    change_table :credits do |t|
      t.remove :currency
      t.remove :balance
      t.remove :created_at
      t.remove :updated_at
      t.column :POINT, :integer, null: false, default: 0
      t.column :CNY, :integer, null: false, default: 0
      t.column :BTC, :integer, null: false, default: 0
      t.column :USD, :integer, null: false, default: 0
    end

    change_table :creditlogs do |t|
      t.remove :updated_at
      t.column :receiver_id, :integer, null: false, default: 1, index: true
      t.column :receiver_balance, :integer, null: false, default: 0
    end
    change_column(:creditlogs, :currency, :integer, null: false, default: 0)
    add_index(:creditlogs, [:user_id, :currency]

    change_column(:events, :currency, :integer, null: false, default: 0)
  end

  def down
    change_table :credits do |t|
      t.remove :POINT
      t.remove :CNY
      t.remove :BTC
      t.remove :USD
      t.column :currency, :string, null: false, index: true
      t.column :balance, :integer, default: 0
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end

    change_table :creditlogs do |t|
      t.remove :receiver_id, :integer, default: 1, index: true
      t.remove :receiver_balance, :integer, default: 0
      t.column :updated_at, :datetime
    end
  end
end
