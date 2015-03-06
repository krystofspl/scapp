class CreateFavoritePlan < ActiveRecord::Migration
  def change
    create_table :favorite_plans do |t|
      t.references :plan, index: true
      t.references :user, index: true
      t.string :name, null: false
      t.text :note

      t.timestamps
    end
  end
end
