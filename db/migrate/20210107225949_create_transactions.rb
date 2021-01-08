class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.integer :status, default: 0
      t.string :external_id

      t.references :order, foreign_key: true, null: false, index: true

      t.timestamps
    end
  end
end
