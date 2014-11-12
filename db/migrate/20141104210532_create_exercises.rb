class CreateExercises < ActiveRecord::Migration
  def up
    create_table :exercises, id: false do |t|
      t.string :code, null: false
      t.integer :version, null: false, :default => 1
      t.string :name, null: false
      t.string :author_name
      t.string :description
      t.string :sources
      t.string :youtube_url
      t.string :type, null: false, default: 'Exercise'
      t.column :accessibility, "ENUM('private', 'global')", default: 'private', null: false
      t.references :user, index: true
      t.integer :exercise_image_id

      t.timestamps
    end
    add_index :exercises, :code
    execute "ALTER TABLE exercises ADD PRIMARY KEY (code,version);"
  end

  def down
    drop_table :exercises
  end
end
