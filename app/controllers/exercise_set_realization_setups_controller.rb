class ExerciseSetRealizationSetupsController < ApplicationController
  before_action :set_exercise_set_realization_setup, only: [:edit, :update, :destroy]

  def new
    @exercise_set_realization_setup = ExerciseSetRealizationSetup.new(exercise_set_realization_setup_params)
    render partial: "exercise_set_realization_setups/form", locals: {exercise_set_realization_setup: @exercise_set_realization_setup}
  end

  def edit
    render partial: "exercise_set_realization_setups/form", locals: {exercise_set_realization_setup: @exercise_set_realization_setup}
  end

  def create
    @exercise_set_realization_setup = ExerciseSetRealizationSetup.new(exercise_set_realization_setup_params)
    puts @exercise_set_realization_setup.inspect
    respond_to do |format|
      if @exercise_set_realization_setup.save
        format.json { render json: @exercise_set_realization_setup }
      else
        format.json { render json: @exercise_set_realization_setup.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @exercise_set_realization_setup.update(exercise_set_realization_setup_params)
        format.json { render json: @exercise_set_realization_setup }
      else
        format.json { render json: @exercise_set_realization_setup.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # If setup is required, forbid deletion
    @exercise_set_realization_setup.is_required?
    if @exercise_set_realization_setup.errors.any?
      @exercise_set_realization_setup.errors.full_messages.each do |err|
        flash[:notice]=err
      end
      return
    end
    respond_to do |format|
      if @exercise_set_realization_setup.destroy
        format.json { head :no_content }
      else
        format.json { render json: @exercise_set_realization_setup.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_exercise_set_realization_setup
      @exercise_set_realization_setup = ExerciseSetRealizationSetup.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white index through.
    def exercise_set_realization_setup_params
      params.require(:exercise_set_realization_setup).permit(:exercise_setup_code, :exercise_set_realization_id, :numeric_value, :string_value, :note)
    end
end