class FavoritePlan < ActiveRecord::Base
  # =================== ASSOCIATIONS =================================
  belongs_to :plan
  belongs_to :user
  # =================== VALIDATIONS ==================================
  validates :name, presence: true
end