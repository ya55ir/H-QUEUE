class CreateTableTypes < ActiveRecord::Migration[8.1]
  def change
    create_table :table_types do |t|
      t.references :venue, null: false, foreign_key: true
      t.integer :capacity
      t.integer :status

      t.timestamps
    end
  end
end
