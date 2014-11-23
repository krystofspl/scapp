class ExerciseMeasurementsController < ApplicationController
  before_action :set_exercise_measurement, only: [:show, :edit, :update, :destroy]

  # GET /exercise_measurements/new
  def new
    #TODO authorize exercise.user==current_user || admin
    @exercise = Exercise.friendly.find([params[:exercise_code],params[:exercise_version]])
    @exercise_measurement = ExerciseMeasurement.new
  end

  # GET /exercise_measurements/1/edit
  def edit
  end

  # POST /exercise_measurements
  # POST /exercise_measurements.json
  def create
    @exercise = Exercise.friendly.find([params[:exercise_measurement][:exercise_code],params[:exercise_measurement][:exercise_version]])
    @exercise_measurement = ExerciseMeasurement.new(exercise_measurement_params)
    respond_to do |format|
      if @exercise_measurement.save
        format.html { redirect_to @exercise, notice: 'Exercise measurement was successfully created.' }
        format.json { render action: 'show', status: :created, location: @exercise_measurement }
      else
        format.html { render action: 'new' }
        format.json { render json: @exercise_measurement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exercise_measurements/1
  # PATCH/PUT /exercise_measurements/1.json
  def update
    respond_to do |format|
      if @exercise_measurement.update(exercise_measurement_params)
        format.html { redirect_to @exercise_measurement, notice: 'Exercise measurement was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @exercise_measurement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exercise_measurements/1
  # DELETE /exercise_measurements/1.json
  def destroy
    @exercise = @exercise_measurement.exercise
    @exercise_measurement.destroy
    respond_to do |format|
      format.html { redirect_to @exercise, notice: t('exercise_measurement.delete.successfully_removed') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exercise_measurement
      @exercise_measurement = ExerciseMeasurement.friendly.find(params[:exercise_measurement_code])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exercise_measurement_params
      params.require(:exercise_measurement).permit(:code, :name, :description, :optimal_value, :unit_code, :exercise_code, :exercise_version)
    end
end
