class CreateExerciseImages < ActiveRecord::Migration
  def change
    create_table :exercise_images do |t|
      t.string :name
      t.string :path, null: false
      t.string :description
      t.column :correctness, "ENUM('right','wrong')", null: false
      t.references :exercise_step, index: true
      t.string :exercise_code, index: true
      t.integer :exercise_version, index: true

      t.timestamps
    end
  end
end
