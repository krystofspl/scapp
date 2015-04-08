class CreateExerciseSetRealization < ActiveRecord::Migration
  def change
    create_table :exercise_set_realizations do |t|
      t.integer :order, null: false
      t.integer :time_duration, null: false, default: 60
      t.integer :rest_after, default: 0
      t.text :note
      t.boolean :completed, null: false, default: true
      t.references :exercise_realization, index: true, null: false
      t.timestamps
    end
  end
end
