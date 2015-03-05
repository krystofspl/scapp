class Exercise < ActiveRecord::Base
  ACCESSIBILITY = [:private, :global]

  self.primary_keys = [:code, :version]
  extend FriendlyId
  friendly_id :name, :use => :slugged, :slug_column => :code
  filterrific :default_filter_params => {sorted_by: 'realizations_desc' },
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
    # configure number of OR conditions for provision
    # of interpolation arguments. Adjust this if you
    # change the number of OR conditions.
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
        # Number of realizations of the exercise
        order("exercise_realizations_count #{ direction }")
      else
        raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }

  # =================== ASSOCIATIONS =================================
  belongs_to :user
  has_many :exercise_bundle_exercises, :class_name => 'ExerciseBundleExercise', :foreign_key => [:exercise_code, :exercise_version]
  has_many :exercise_bundles, :through => :exercise_bundle_exercises
  has_many :exercise_steps, :foreign_key => [:exercise_code, :exercise_version], :dependent => :delete_all
  has_many :exercise_setups, :foreign_key => [:exercise_code, :exercise_version], :dependent => :delete_all
  has_many :exercise_measurements, :foreign_key => [:exercise_code, :exercise_version], :dependent => :delete_all
  has_one :exercise_image, :foreign_key => [:exercise_code, :exercise_version], :dependent => :destroy
  accepts_nested_attributes_for :exercise_image, allow_destroy: true
  # --- prototypes for v2
  has_many :exercise_realizations, :foreign_key => [:exercise_code, :exercise_version], :dependent => :restrict_with_error

  # =================== VALIDATIONS ==================================
  validates :code, presence: true
  validates :version, presence: true
  validates :name, presence: true
  #TODO nefunguje a hází validates :name, uniqueness: true, unless: :version>1
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

  # =================== METHODS ======================================
  # Does the exercise have any realizations?
  def is_in_use?
    !self.exercise_realizations.empty?
  end

  # Return exercise_code(/version/) string
  def relative_url
    read_attribute(:code) + ((read_attribute(:version).to_i>1) ? ("/v/"+read_attribute(:version).to_s) : "")
  end

  # Return exercises/exercise_code(/version/) string
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
        [I18n.t('exercise.filter.realizations_asc'), 'realizations_asc'],
        [I18n.t('exercise.filter.realizations_desc'), 'realizations_desc'],

    ]
  end
end