class CreatePlan < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.references :training_lesson_realization, index: true
      t.boolean :is_scheduled
      t.integer :user_created
      t.integer :user_partook

      t.timestamps
    end
  end
end
