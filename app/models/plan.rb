class Plan < ActiveRecord::Base
  # =================== ASSOCIATIONS =================================
  belongs_to :training_lesson_realization
  belongs_to :user_created, :class_name => 'User'
  belongs_to :user_partook, :class_name => 'User'
  has_many :exercise_realizations
  has_many :favorite_plans
end
