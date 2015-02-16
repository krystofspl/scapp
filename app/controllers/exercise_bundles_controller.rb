class ExerciseBundlesController < ApplicationController
  before_action :set_exercise_bundle, only: [:show, :edit, :update, :destroy]

  # GET /exercise_sets
  # GET /exercise_bundles.json
  def index
    if current_user.is_admin?
      @exercise_bundles = ExerciseBundle.all
    else
      global = ExerciseBundle.where(:accessibility => :global)
      private = ExerciseBundle.where(:user => current_user)
      @exercise_bundles =  (global + private).uniq
    end
  end

  # GET /exercise_bundles/1
  # GET /exercise_bundles/1.json
  def show
  end

  # GET /exercise_bundles/new
  def new
    @exercise_bundle = ExerciseBundle.new
  end

  # GET /exercise_bundles/1/edit
  def edit
  end

  # POST /exercise_bundles
  # POST /exercise_bundles.json
  def create
    @exercise_bundle = ExerciseBundle.new(exercise_bundle_params)
    @exercise_bundle.user = current_user

    respond_to do |format|
      if @exercise_bundle.save
        format.html { redirect_to @exercise_bundle, notice: 'Exercise bundle was successfully created.' }
        format.json { render action: 'show', status: :created, location: @exercise_bundle }
      else
        format.html { render action: 'new' }
        format.json { render json: @exercise_bundle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exercise_bundles/1
  # PATCH/PUT /exercise_bundles/1.json
  def update
    respond_to do |format|
      if @exercise_bundle.update(exercise_bundle_params)
        format.html { redirect_to @exercise_bundle, notice: 'Exercise bundle was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @exercise_bundle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exercise_bundles/1
  # DELETE /exercise_bundles/1.json
  def destroy
    @exercise_bundle.destroy
    respond_to do |format|
      format.html { redirect_to exercise_bundles_url, notice: 'Exercise bundle was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  # GET /users/test/exercise_bundles
  def user_exercise_bundles
    authorize! :user_exercise_bundles, ExerciseBundlesController
    @user = User.friendly.find(params[:user_id])
    @exercise_bundles = ExerciseBundle.where(:user=>@user)
    render 'users/exercise_bundles/list'
  end

  # GET /exercise_bundles/id/edit_exercises
  def edit_exercises
    @exercise_bundle = ExerciseBundle.friendly.find(params[:id])
    if @exercise_bundle.accessibility==:global
      @exercises = Exercise.where(:accessibility => :global)
    elsif @exercise_bundle.accessibility==:private
      @exercises = (Exercise.where(:accessibility => :global) + Exercise.where(:user => current_user)).uniq
    end
  end

  def add_exercise
    exercise = Exercise.friendly.find([params[:exercise_code],params[:exercise_version]])
    exercise_bundle = ExerciseBundle.friendly.find(params[:id])
    exercise_bundle.exercises << exercise
    flash[:notice] = t('exercise_bundle.edit_exercises.exercise_successfully_included')
    redirect_to :controller => :exercise_bundles, :action => :edit_exercises, :id => exercise_bundle.id
  end

  def remove_exercise
    exercise = Exercise.friendly.find([params[:exercise_code],params[:exercise_version]])
    exercise_bundle = ExerciseBundle.friendly.find(params[:id])
    # bug - nefunguje exercise_bundle.exercises.delete(exercise), delam to manualne pres join table
    exercise_bundle.exercise_bundle_exercises.where(:exercise_bundle_code=>exercise_bundle.code,:exercise_code=>exercise.code,:exercise_version=>exercise.version).first.delete
    flash[:notice] = t('exercise_bundle.edit_exercises.exercise_successfully_removed')
    redirect_to :controller => :exercise_bundles, :action => :edit_exercises, :id => exercise_bundle.id
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exercise_bundle
      @exercise_bundle = ExerciseBundle.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exercise_bundle_params
      params.require(:exercise_bundle).permit(:code, :name, :description, :accessibility, :user_id)
    end
end
