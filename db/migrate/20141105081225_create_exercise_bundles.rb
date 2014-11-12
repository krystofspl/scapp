class CreateExerciseBundles < ActiveRecord::Migration
  def change
    create_table :exercise_bundles, id: false do |t|
      t.string :code, null: false, unique: true
      t.string :name, null: false
      t.string :description
      t.column :accessibility, "ENUM('private', 'global')", default: 'private', null: false
      t.references :user, index: true

      t.timestamps
    end
    add_index :exercise_bundles, :code
    execute "ALTER TABLE exercise_bundles ADD PRIMARY KEY (code);"
  end
end
