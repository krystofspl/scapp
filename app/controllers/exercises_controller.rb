class ExercisesController < ApplicationController
  before_action :set_exercise, only: [:show, :edit, :update, :destroy]
  include ExercisesHelper

  # GET /exercises
  # GET /exercises.json
  def index
    authorize! :index, Exercise
    exercises_private = Exercise.where(:user=>current_user)
    exercises_global = Exercise.where(:accessibility => 'global')
    @exercises = exercises_private + exercises_global
    @exercises = @exercises.uniq
  end

  # GET /exercises/1
  # GET /exercises/1.json
  def show
    authorize! :show, @exercise
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
        format.html {
          #TODO zobrazit stranku s odkazy na úpravu detailů
          if params[:commit] == "Create exercise without adding details"
            redirect_to @exercise, notice: 'Exercise was successfully created.'
          elsif params[:commit] == "Create exercise and add details"
            redirect_to @exercise, notice: 'Exercise was successfully created.'
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
        format.html { redirect_to exercise_path(@exercise), notice: 'Exercise successfully updated.' }
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
    new_exercise_version = Exercise.all.order('version').last.version+1
    # Exercise
    existing_exercise = Exercise.friendly.find([params[:exercise_code],existing_exercise_version])

    authorize! :clone, existing_exercise

    @exercise = existing_exercise.deep_dup
    @exercise.code = existing_exercise.code
    @exercise.version = new_exercise_version
    # Measurements
    existing_exercise.exercise_measurements.each do |measurement|
      new = measurement.deep_dup
      new.exercise_version = new_exercise_version
      new.save
      @exercise.exercise_measurements << new
    end
    # Setups
    existing_exercise.exercise_setups.each do |setup|
      new = setup.deep_dup
      new.exercise_version = new_exercise_version
      new.save
      @exercise.exercise_setups << new
    end
    # Steps
    existing_exercise.exercise_steps.each do |step|
      new = step.deep_dup
      new.exercise_version = new_exercise_version
      new.save
      @exercise.exercise_steps << new
    end
    @exercise.save
    render action: 'edit'
  end

  # GET /users/test/exercises
  def user_exercises
    authorize! :user_exercises, Exercise
    @user = User.friendly.find(params[:user_id])
    @exercises = Exercise.where(:user => @user)
    render 'users/exercises/list'
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def exercise_params
      params.require(:exercise).permit(:code, :version, :name, :author_name, :description, :sources, :youtube_url, :accessibility, :type, :user_id, :exercise_image_id)
    end
end
