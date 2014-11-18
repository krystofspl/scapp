class ExercisesController < ApplicationController
  before_action :set_exercise, only: [:show, :edit, :update, :destroy]

  # GET /exercises
  # GET /exercises.json
  def index
    authorize! :exercises_list, ExercisesController
    exercises_private = Exercise.where(:user=>current_user)
    exercises_global = Exercise.where(:accessibility => 'global')
    @exercises = exercises_private + exercises_global
    @exercises = @exercises.uniq
  end

  # GET /exercises/1
  # GET /exercises/1.json
  def show
    authorize! :exercise_detail, ExercisesController
    @exercise_setups = @exercise.exercise_setups
    @exercise_measurements = @exercise.exercise_measurements
    @exercise_bundles = @exercise.exercise_bundles
  end

  # GET /exercises/new
  def new
    authorize! :exercise_new, ExercisesController
    @exercise = Exercise.new
  end

  # GET /exercises/1/edit
  def edit
    #TODO authorize
  end

  # POST /exercises
  # POST /exercises.json
  def create
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

  # PATCH/PUT /exercises/1
  # PATCH/PUT /exercises/1.json
  def update
    respond_to do |format|
      if @exercise.update(exercise_params)
        format.html { redirect_to @exercise, notice: 'Exercise successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @exercise.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exercises/1
  # DELETE /exercises/1.json
  def destroy
    @exercise.destroy
    respond_to do |format|
      format.html { redirect_to exercises_url, notice: t('exercise.successfully_removed') }
      format.json { head :no_content }
    end
  end

  # GET /users/test/exercises
  def user_exercises
    authorize! :user_exercises, ExercisesController
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
