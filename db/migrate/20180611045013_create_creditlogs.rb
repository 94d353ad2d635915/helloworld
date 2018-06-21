class CreateCreditlogs < ActiveRecord::Migration[5.2]
  def up
    create_table :creditlogs do |t|
      t.references :user
      t.references :eventlog
      t.string :currency
      t.integer :amount
      t.integer :balance
    end

    change_table(:events) do |t|
      t.column :currency, :string
      t.column :amount, :integer, default: 0
    end

    # remove all fk, fk is evil.
    # here is not effect. just show data.
    # disable and remove foreign_key: true, default: false
    # delete fk from database by manual.
    fk_tables = tables - ['schema_migrations','ar_internal_metadata']
    fk_tables.each do |table|
      foreign_keys(table).each do |fk|
        puts fk
        remove_foreign_key fk[:from_table].to_sym, fk[:to_table].to_sym
      end
    end
  end

  def down
    drop_table :creditlogs
    change_table(:events) do |t|
      t.remove :currency
      t.remove :amount
    end
  end
end
