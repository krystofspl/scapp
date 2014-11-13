class CreateExerciseMeasurements < ActiveRecord::Migration
  def up
    create_table :exercise_measurements, id: false do |t|
      t.string :code, null: false, unique: true
      t.string :name, null: false
      t.string :description
      t.string :type, null: false, default: 'ExerciseMeasurement'
      t.column :optimal_value, "ENUM('higher','lower')", default: 'higher', null: false
      t.string :unit_code, index: true
      t.string :exercise_code, index: true
      t.integer :exercise_version, index: true

      t.timestamps
    end
    add_index :exercise_measurements, :code
    execute "ALTER TABLE exercise_measurements ADD PRIMARY KEY (code);"
  end

  def down
    drop_table :exercise_measurements
  end
end
