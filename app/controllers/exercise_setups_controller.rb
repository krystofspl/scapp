class ExerciseSetupsController < ApplicationController
  before_action :set_exercise_setup, only: [:show, :edit, :update, :destroy]

  # GET /exercise_setups/1
  # GET /exercise_setups/1.json
  def show
  end

  # GET /exercise_setups/new
  def new
    @exercise = Exercise.friendly.find([params[:exercise_code],params[:exercise_version]])
    @exercise_setup = ExerciseSetup.new
  end

  # GET /exercise_setups/1/edit
  def edit
  end

  # POST /exercise_setups
  # POST /exercise_setups.json
  def create
    @exercise = Exercise.friendly.find([params[:exercise_setup][:exercise_code],params[:exercise_setup][:exercise_version]])
    @exercise_setup = ExerciseSetup.new(exercise_setup_params)

    respond_to do |format|
      if @exercise_setup.save
        format.html { redirect_to @exercise, notice: 'Exercise setup was successfully created.' }
        format.json { render action: 'show', status: :created, location: @exercise_setup }
      else
        format.html { render action: 'new' }
        format.json { render json: @exercise_setup.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exercise_setups/1
  # PATCH/PUT /exercise_setups/1.json
  def update
    respond_to do |format|
      if @exercise_setup.update(exercise_setup_params)
        format.html { redirect_to @exercise_setup, notice: 'Exercise setup was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @exercise_setup.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exercise_setups/1
  # DELETE /exercise_setups/1.json
  def destroy
    @exercise = @exercise_setup.exercise
    @exercise_setup.destroy
    respond_to do |format|
      format.html { redirect_to @exercise, notice: t('exercise_setup.delete.successfully_removed') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exercise_setup
      @exercise_setup = ExerciseSetup.friendly.find(params[:exercise_setup_code])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exercise_setup_params
      params.require(:exercise_setup).permit(:code, :name, :description, :required, :exercise_setup_type_id, :unit_code, :exercise_code, :exercise_version)
    end
end