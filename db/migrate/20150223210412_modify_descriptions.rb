class ModifyDescriptions < ActiveRecord::Migration
  def up
    change_column :exercise_setups, :description, :text
    change_column :exercise_measurements, :description, :text
    change_column :exercises, :description, :text
    change_column :exercise_bundles, :description, :text
    add_column :exercises, :description_long, :text
    add_column :exercise_bundles, :description_long, :text
  end
  def down
    change_column :exercise_setups, :description, :string
    change_column :exercise_measurements, :description, :string
    change_column :exercises, :description, :string
    change_column :exercise_bundles, :description, :string
    remove_column :exercises, :description_long
    remove_column :exercise_bundles, :description_long
  end
end
