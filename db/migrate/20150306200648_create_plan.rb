class CreatePlan < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.references :training_lesson_realization, index: true
      t.boolean :is_scheduled, null: false, default: false
      t.integer :user_created_id
      t.integer :user_partook_id

      t.timestamps
    end
  end
end
