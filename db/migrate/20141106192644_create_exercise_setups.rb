class CreateExerciseSetups < ActiveRecord::Migration
  def up
    create_table :exercise_setups, id: false do |t|
      t.string :code, null: false, unique: true
      t.string :name, null: false
      t.string :description
      t.string :type, null: false, default: 'ExerciseSetup'
      t.boolean :required, null: false, default: false
      t.references :exercise_setup_type, index: true
      t.references :unit, index: true
      t.references :exercise, index: true

      t.timestamps
    end
    add_index :exercise_setups, :code
    execute "ALTER TABLE exercise_setups ADD PRIMARY KEY (code);"
  end

  def down
    drop_table :exercise_setups
  end
end
