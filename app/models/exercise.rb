class Exercise < ActiveRecord::Base
  ACCESSIBILITY = [:private, :global]

  self.primary_keys = [:code, :version]

  extend FriendlyId
  friendly_id :name, :use => :slugged, :slug_column => :code

  # Filtering
  filterrific :default_filter_params => {sorted_by: 'created_at_desc' },
      :available_filters => [:sorted_by,:search_query]

  # =================== SCOPES =======================================
  scope :search_query, lambda { |query|
    return nil if query.blank?
    # condition query, parse into individual keywords
    terms = query.downcase.split(/\s+/)
    # replace "*" with "%" for wildcard searches,
    # append '%', remove duplicate '%'s
    terms = terms.map { |e|
     (e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    # configure number of OR conditions for provision of interpolation arguments
    num_or_conds = 2
    where(
       terms.map { |term|
         "(LOWER(exercises.name) LIKE ? OR LOWER(exercises.description) LIKE ?)"
       }.join(' AND '),
       *terms.map { |e| [e] * num_or_conds }.flatten
    )
  }
  scope :sorted_by, lambda { |sort_option|
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
      when /^created_at_/
        # Simple sort on the created_at column.
        order("exercises.created_at #{ direction }")
      when /^name_/
        # Simple sort on the name colums
        order("LOWER(exercises.name) #{ direction }")
      when /^realizations_/
        #TODO this currently doesn't work, can't get the query to include exercises with 0 realizations
        # Number of realizations of the exercise
        select("exercises.*, count(exercise_realizations.id) as realizations_count")
            .joins("LEFT OUTER JOIN exercise_realizations ON exercises.code=exercise_realizations.exercise_code AND exercises.version=exercise_realizations.exercise_version")
            .order("realizations_count #{direction}")
      else
        raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }
  scope :accessible, lambda { |user|
    if user.is_admin?
      where(true)
    elsif user.is_coach?
      where('accessibility=? OR user_id=?',:global,user.id)
    elsif user.is_player?
      joins({:exercise_realizations=>{:plan=>:user_partook}}).where('plans.user_partook_id=?',user.id)
    end
  }

  # =================== ASSOCIATIONS =================================
  belongs_to :user
  has_many :exercise_bundle_exercises, :class_name => 'ExerciseBundleExercise', :foreign_key => [:exercise_code, :exercise_version]
  has_many :exercise_bundles, :through => :exercise_bundle_exercises
  has_many :exercise_steps, :foreign_key => [:exercise_code, :exercise_version], :dependent => :destroy
  has_many :exercise_setups, :foreign_key => [:exercise_code, :exercise_version], :dependent => :destroy
  has_many :exercise_measurements, :foreign_key => [:exercise_code, :exercise_version], :dependent => :destroy
  has_one :exercise_image, :foreign_key => [:exercise_code, :exercise_version], :dependent => :destroy
  accepts_nested_attributes_for :exercise_image, allow_destroy: true
  has_many :exercise_realizations, :foreign_key => [:exercise_code, :exercise_version], :dependent => :restrict_with_error, :inverse_of => :exercise

  # =================== VALIDATIONS ==================================
  validates :code, presence: true
  validates :version, presence: true
  validates :name, presence: true
  validates :name, uniqueness: true, unless: Proc.new { |ex| ex.version > 1 }
  validates :accessibility, inclusion: { in: ACCESSIBILITY }

  # =================== GETTERS / SETTERS ============================

  # Read accessibility
  # @return [Symbol] accessibility
  def accessibility
    read_attribute(:accessibility).to_sym unless read_attribute(:accessibility).blank?
  end

  # Set accessibility
  # @param accessibility
  #   @option :private
  #   @option :global
  def accessibility=(accessibility)
    write_attribute(:accessibility, accessibility.to_s) unless accessibility.blank?
  end

  def type_to_s
    if self.has_sets?
      I18n.t('exercise.dictionary.exercise_with_sets')
    else
      I18n.t('exercise.dictionary.simple_exercise')
    end
  end

  # =================== METHODS ======================================
  # Return deep clone of self
  # Can't use deep_cloneable because of composite primary key
  def clone
    exercise = self.deep_dup
    exercise.code = self.code
    exercise.version = Exercise.where(:code=>self.code).last.version+1
    # Measurements
    self.exercise_measurements.each do |measurement|
      new = measurement.deep_dup
      new.exercise_version = exercise.version
      new.save
      exercise.exercise_measurements << new
    end
    # Setups
    self.exercise_setups.each do |setup|
      new = setup.deep_dup
      new.exercise_version = exercise.version
      new.save
      exercise.exercise_setups << new
    end
    # Steps
    self.exercise_steps.each do |step|
      new = step.deep_dup
      new.exercise_version = exercise.version
      new.save
      exercise.exercise_steps << new
      #TODO Images
    end
    #TODO Image
    exercise
  end

  # Does the exercise have any realizations?
  # @return [boolean]
  def is_in_use?
    !self.exercise_realizations.empty?
  end

  # Is exercise of type ExerciseWithSets?
  # @return [boolean]
  def has_sets?
    self.type=='ExerciseWithSets'
  end

  # Is exercise accessibility private?
  # @return [boolean]
  def is_private?
    self.accessibility == :private
  end

  # Is exercise accessibility global?
  # @return [boolean]
  def is_global?
    self.accessibility == :global
  end

  # Return exercise_code(/version/) string
  # @return [string]
  def relative_url
    read_attribute(:code) + ((read_attribute(:version).to_i>1) ? ("/v/"+read_attribute(:version).to_s) : "")
  end

  # Override to_s and return name with version string
  # @return [string]
  def to_s
    read_attribute(:name) + ((read_attribute(:version).to_i>1) ? (" (v"+read_attribute(:version).to_s+")") : "")
  end

  # Return exercises/exercise_code(/version/) string
  # @return [string]
  def url
    "/exercises/#{relative_url}"
  end

  # This method provides select options for the `sorted_by` filter select input.
  # It is called in the controller as part of `initialize_filterrific`.
  def self.options_for_sorted_by
    [
        [I18n.t('exercise.filter.name_asc'), 'name_asc'],
        [I18n.t('exercise.filter.name_desc'), 'name_desc'],
        [I18n.t('exercise.filter.created_at_asc'), 'created_at_asc'],
        [I18n.t('exercise.filter.created_at_desc'), 'created_at_desc'],
        #[I18n.t('exercise.filter.realizations_asc'), 'realizations_asc'],
        #[I18n.t('exercise.filter.realizations_desc'), 'realizations_desc'],
    ]
  end
end