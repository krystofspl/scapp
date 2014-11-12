class CreateExerciseSetupTypes < ActiveRecord::Migration
  def change
    create_table :exercise_setup_types, id: false do |t|
      t.string :code, null: false, unique: true
      t.string :name, null: false
      t.string :description

      t.timestamps
    end
    add_index :exercise_setup_types, :code
    execute "ALTER TABLE exercise_setup_types ADD PRIMARY KEY (code);"
  end
end
