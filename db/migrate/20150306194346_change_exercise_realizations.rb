class ChangeExerciseRealizations < ActiveRecord::Migration
  def change
    change_table :exercise_realizations do |t|
      # Attributes
      t.integer :order, null: false
      t.integer :time_duration, null: false, default: 300
      t.integer :rest_after, default: 0
      t.text :note
      t.boolean :completed, null: false, default: true
      t.timestamps

      # Associations (exercise code, version are present yet)
      t.integer :user_created_id
      t.integer :user_measured_id
      t.references :plan, index: true, null: false
    end
  end
end
