class ExerciseRealizationSetupsController < ApplicationController
  before_action :set_exercise_realization_setup, only: [:edit, :update]

  def new
    @exercise_realization_setup = ExerciseRealizationSetup.new(exercise_realization_setup_params)
    render partial: "exercise_realization_setups/form", locals: {exercise_realization_setup: @exercise_realization_setup}
  end

  def edit
    render partial: "exercise_realization_setups/form", locals: {exercise_realization_setup: @exercise_realization_setup}
  end

  def create
    @exercise_realization_setup = ExerciseRealizationSetup.new(exercise_realization_setup_params)
    respond_to do |format|
      if @exercise_realization_setup.save
        format.json { render json: @exercise_realization_setup }
      else
        format.json { render json: @exercise_realization_setup.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @exercise_realization_setup.update(exercise_realization_setup_params)
        format.json { render json: @exercise_realization_setup }
      else
        format.json { render json: @exercise_realization_setup.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @exercise_realization_setup = ExerciseRealizationSetup.find(params[:id])
    # If setup is required, forbid deletion
    @exercise_realization_setup.is_required?
    if @exercise_realization_setup.errors.any?
      @exercise_realization_setup.errors.full_messages.each do |err|
        flash[:notice]=err
      end
      return
    end
    respond_to do |format|
      if @exercise_realization_setup.destroy
        format.json { head :no_content }
      else
        format.json { render json: @exercise_realization_setup.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_exercise_realization_setup
      @exercise_realization_setup = ExerciseRealizationSetup.find(exercise_realization_setup_params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def exercise_realization_setup_params
      params.require(:exercise_realization_setup).permit(:id, :exercise_setup_code, :exercise_realization_id, :numeric_value, :string_value, :note)
    end
end