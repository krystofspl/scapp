class DeleteExerciseImagePath < ActiveRecord::Migration
  def up
    remove_column :exercise_images, :path
    add_column :exercise_images, :image, :string
  end
  def down
    add_column :exercise_images, :path, :text
    remove_column :exercise_images, :image
  end
end
