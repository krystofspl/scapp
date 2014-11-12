class CreateUnits < ActiveRecord::Migration
  def up
    create_table :units, id: false do |t|
      t.string :code, null: false, unique: true
      t.string :name, null: false
      t.string :description
      t.string :abbreviation, null: false, unique: true
      t.column :unit_type, "ENUM('integer','decimal','time')", default: 'integer', null: false

      t.timestamps
    end
    add_index :units, :code
    execute "ALTER TABLE units ADD PRIMARY KEY (code);"
  end

  def down
    drop_table :units
  end
end
