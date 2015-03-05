class ExerciseImage < ActiveRecord::Base
  #TODO muze byt rozsireno o name a desc v budoucnu, v migraci to uz je
  CORRECTNESS = [:right, :wrong]
  mount_uploader :image, ExerciseImageUploader

  # =================== SCOPES =======================================
  scope :right, -> { where(correctness: :right) }
  scope :wrong, -> { where(correctness: :wrong) }

  # =================== ASSOCIATIONS =================================
  belongs_to :exercise_step
  belongs_to :exercise,  :foreign_key => [:exercise_code, :exercise_version]

  # =================== VALIDATIONS ==================================
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

  # Remove avatars first, then the entity
  def destroy
    self.remove_image!
    super
  end
end
