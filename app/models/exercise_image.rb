class ExerciseImage < ActiveRecord::Base
  CORRECTNESS = [:right, :wrong]

  # =================== ASSOCIATIONS =================================
  belongs_to :exercise_step
  belongs_to :exercise,  :foreign_key => [:exercise_code, :exercise_version]

  # =================== VALIDATIONS ==================================
  validates :path, presence: true
  validates :correctness, inclusion: { in: CORRECTNESS }

  # =================== GETTERS / SETTERS ============================

  # Read correctness
  # @return [Symbol] correctness
  def correctness
    read_attribute(:correctness).to_sym unless read_attribute(:correctness).blank?
  end

  # Set correctness
  # @param correctness
  #   @option :right
  #   @option :wrong
  def correctness=(correctness)
    write_attribute(:correctness, correctness.to_s)
  end
end
