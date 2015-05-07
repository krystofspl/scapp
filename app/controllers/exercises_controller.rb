class ExercisesController < ApplicationController
  before_action :set_exercise, only: [:show, :edit, :update, :destroy, :filterrific_setups, :filterrific_measurements]
  include ExercisesHelper

  # GET /exercises
  # GET /exercises.json
  def index
    authorize! :index, Exercise
    filterrific_exercises or return
    @exercises = @filterrific.find.accessible(current_user).uniq.page(params[:page]).per(10)
  end

  # GET /exercises/1
  # GET /exercises/1.json
  def show
    authorize! :show, @exercise
    filterrific_setups
    filterrific_measurements
  end

  # GET /exercises/new
  def new
    authorize! :create, Exercise
    @exercise = Exercise.new
  end

  # POST /exercises
  # POST /exercises.json
  def create
    authorize! :create, Exercise
    @exercise = Exercise.new(exercise_params)
    @exercise.user = current_user

    respond_to do |format|
      if @exercise.save
        upload_images
        format.html {
          if params[:commit] == t('exercise.new.form_button_create')
            redirect_to exercises_path, notice: t('exercise.successfuly_created')
          elsif params[:commit] == t('exercise.new.form_button_create_add_details')
            redirect_to @exercise, notice: t('exercise.successfuly_created')
          else
            redirect_to exercises_path, notice: t('exercise.successfuly_created')
          end
        }
        format.json { render action: 'show', status: :created, location: @exercise }
      else
        format.html { render action: 'new' }
        format.json { render json: @exercise.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /exercises/1/edit
  def edit
    authorize! :edit, @exercise
  end

  def update
    authorize! :edit, @exercise
    respond_to do |format|
      if @exercise.update(exercise_params)
        upload_images
        format.html { redirect_to exercise_path(@exercise), notice: t('exercise.successfully_updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @exercise.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize! :destroy, @exercise
    @exercise.destroy
    respond_to do |format|
      format.html { redirect_to exercises_url, notice: t('exercise.successfully_removed') }
      format.json { head :no_content }
    end
  end

  def clone
    existing_exercise_version = (params[:exercise_version].blank?) ? 1 : params[:exercise_version]
    # Exercise
    existing_exercise = Exercise.friendly.find([params[:exercise_code],existing_exercise_version])

    authorize! :clone, existing_exercise
    @exercise = existing_exercise.clone
    @exercise.save!
    render action: 'edit'
  end

  # GET /users/test/exercises
  def user_exercises
    authorize! :user_exercises, Exercise
    @user = User.friendly.find(params[:user_id])
    filterrific_exercises or return
    @exercises = @filterrific.find.where(:user => @user).page(params[:page]).per(10)
    respond_to do |format|
      format.html { render 'users/exercises/list' }
      # JS requests are handled for filterrific
      format.js { render 'user_exercises' }
    end
  end

  #### Filterrific sub-filters
  # Init filterrific for Exercise entity
  def filterrific_exercises
    @filterrific = initialize_filterrific(
        Exercise,
        params[:filterrific],
        :select_options => {
            sorted_by: Exercise.options_for_sorted_by
        }
    ) or return
    rescue ActiveRecord::RecordNotFound => e
      # There is an issue with the persisted param_set. Reset it.
      redirect_to(reset_filterrific_url(format: :js)) and return
  end

  # Init filterrific for ExerciseSetup entity
  def filterrific_setups
    fs_select_options = Hash.new
    fs_select_options[:sorted_by] = ExerciseSetup.options_for_sorted_by
    fs_select_options[:type] = ExerciseSetup.options_for_type if @exercise.has_sets?
    @filterrific_setups = initialize_filterrific(
        ExerciseSetup,
        params[:filterrific_setups],
        :select_options => fs_select_options
    ) or return
    # Recover from invalid param sets, e.g., when a filter refers to the
    # database id of a record that doesn’t exist any more.
    # In this case we reset filterrific and discard all filter params.
    @exercise_setups = @filterrific_setups.find.for_exercise(@exercise).page(params[:page_s]).per(3)
    rescue ActiveRecord::RecordNotFound => e
      # There is an issue with the persisted param_set. Reset it.
      redirect_to(reset_filterrific_url(format: :html)) and return
  end

  # Init filterrific for ExerciseMeasurement entity
  def filterrific_measurements
    fm_select_options = Hash.new
    fm_select_options[:sorted_by] = ExerciseMeasurement.options_for_sorted_by
    fm_select_options[:type] = ExerciseMeasurement.options_for_type if @exercise.has_sets?
    @filterrific_measurements = initialize_filterrific(
        ExerciseMeasurement,
        params[:filterrific_measurements],
        :select_options => fm_select_options
    ) or return
    @exercise_measurements = @filterrific_measurements.find.for_exercise(@exercise).page(params[:page_m]).per(3)
    # Recover from invalid param sets, e.g., when a filter refers to the
    # database id of a record that doesn’t exist any more.
    # In this case we reset filterrific and discard all filter params.
    rescue ActiveRecord::RecordNotFound => e
      # There is an issue with the persisted param_set. Reset it.
      redirect_to(reset_filterrific_url(format: :html)) and return
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exercise
      begin
        ver = params[:exercise_version].nil? ? 1 : params[:exercise_version]
        @exercise = Exercise.friendly.find([params[:exercise_code],ver])
      rescue ActiveRecord::RecordNotFound
        redirect_to dashboard_path, notice: 'Exercise not found.'
      end
    end

    # Never trust parameters from the scary internet, only allow the white index through.
    def exercise_params
      params.require(:exercise).permit(:code, :version, :name, :author_name, :description, :description_long, :sources, :youtube_url, :accessibility, :type, :user_id, :exercise_image_id)
    end

    # Create ExerciseImage entity for each image from the form
    def upload_images
      if params[:images]
        params[:images].each { |image|
          img = ExerciseImage.create(image: image, correctness: :right)
          @exercise.exercise_image = img
        }
      end
    end
end
