class AddRealizationsCountColumn < ActiveRecord::Migration
  def change
    add_column :exercises, :exercise_realizations_count, :integer, default: 0
    add_column :exercise_setups, :exercise_realization_setups_count, :integer, default: 0
    add_column :exercise_measurements, :exercise_realization_measurements_count, :integer, default: 0
  end
end
