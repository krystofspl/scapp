class ExerciseSetup < ActiveRecord::Base

  self.primary_key = :code
  extend FriendlyId
  friendly_id :name, :use => :slugged, :slug_column => :code
  filterrific :default_filter_params => {sorted_by: 'name_asc', type: 'all'},
              :available_filters => [:sorted_by,:type,:search_query]

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
    # configure number of OR conditions for provision
    # of interpolation arguments. Adjust this if you
    # change the number of OR conditions.
    num_or_conds = 2
    where(
       terms.map { |term|
         "(LOWER(exercise_setups.name) LIKE ? OR LOWER(exercise_setups.description) LIKE ?)"
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
        order("exercise_setups.created_at #{ direction }")
      when /^name_/
        # Simple sort on the name colums
        order("LOWER(exercise_setups.name) #{ direction }")
      when /^realizations_/
        # Number of realizations of the exercise, done with counter_cache on association
        order("exercise_realization_setups_count #{ direction }")
      else
        raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }
  scope :type, lambda { |type|
    case type.to_s
      when /^all/
        where('exercise_setups.type = ? OR exercise_setups.type = ?','ExerciseSetup','ExerciseSetSetup')
      when /^simple_setups/
        where('exercise_setups.type = ?','ExerciseSetup')
      when /^set_setups/
        where('exercise_setups.type = ?','ExerciseSetSetup')
      else
        raise(ArgumentError, "Invalid type option: #{ type.inspect }")
    end
  }

  # Scope for filtering by given exercise, it's used by Filterrific
  scope :for_exercise, lambda { |exercise|
    where('exercise_code=? AND exercise_version=?', exercise.code, exercise.version)
  }

  scope :required, -> {where(required: true)}

  scope :except_required, -> {where(required: false)}

  # =================== ASSOCIATIONS =================================
  belongs_to :exercise_setup_type, :foreign_key => :exercise_setup_type_code
  belongs_to :unit, :foreign_key => :unit_code
  belongs_to :exercise, :foreign_key => [:exercise_code, :exercise_version]
  has_many :exercise_realization_setups, :foreign_key => :exercise_setup_code

  # =================== VALIDATIONS ==================================
  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
  validates :unit_code, presence: true
  validates :required, inclusion: { in: [true,false]}

  # =================== GETTERS / SETTERS ============================

  # =================== HELPERS ======================================
  def is_required?
    self.read_attribute(:required)
  end

  # Does the exercise setup have any realizations?
  def is_in_use?
    !self.exercise_realization_setups.empty?
  end

  # This method provides select options for the `sorted_by` filter select input.
  # It is called in the controller as part of `initialize_filterrific`.
  def self.options_for_sorted_by
    [
      [I18n.t('exercise.filter.name_asc'), 'name_asc'],
      [I18n.t('exercise.filter.name_desc'), 'name_desc'],
      [I18n.t('exercise.filter.created_at_asc'), 'created_at_asc'],
      [I18n.t('exercise.filter.created_at_desc'), 'created_at_desc'],
      [I18n.t('exercise.filter.realizations_asc'), 'realizations_asc'],
      [I18n.t('exercise.filter.realizations_desc'), 'realizations_desc'],
    ]
  end

  # This method provides select options for the `type` filter select input.
  # It is called in the controller as part of `initialize_filterrific`.
  def self.options_for_type
    [
        [I18n.t('dictionary.all'), 'all'],
        [I18n.t('exercise_setup.simple_setup'), 'simple_setups'],
        [I18n.t('exercise_setup.set_setup'), 'set_setups']
    ]
  end
end
