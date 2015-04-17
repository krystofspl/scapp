class ChangeRealizationsOrderColumnName < ActiveRecord::Migration
  # SQL errors occur when column named 'order' is used for RankedModel,
  # so a change is needed
  def up
    rename_column :exercise_realizations, :order, :row_order
    rename_column :exercise_set_realizations, :order, :row_order
  end
  def down
    rename_column :exercise_realizations, :row_order, :order
    rename_column :exercise_set_realizations, :row_order, :order
  end
end
