class FavoritePlan < ActiveRecord::Base
  # =================== ASSOCIATIONS =================================
  belongs_to :plan, :dependent => :destroy
  belongs_to :user
  # =================== VALIDATIONS ==================================
  validates :name, presence: true
end