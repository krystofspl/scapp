class ExerciseSetRealizationsController < ApplicationController
  helper ExerciseRealizationsHelper
  before_action :set_exercise_set_realization, only: [:edit, :update, :destroy, :update_row_order, :edit_set_setups, :list_exercise_set_realization_setups ]

  def new
    @exercise_set_realization = ExerciseSetRealization.new(exercise_set_realization_params)
    render partial: "exercise_set_realizations/form", locals: {exercise_set_realization: @exercise_set_realization, action: 'new'}
  end

  def create
    @exercise_set_realization = ExerciseSetRealization.new(exercise_set_realization_params)
    # Add at the end of the list
    @exercise_set_realization.update_attribute :order_position, 1000 # set to last position
    respond_to do |format|
      if @exercise_set_realization.save!
        format.json { render json: @exercise_set_realization }
      else
        format.json { render json: @exercise_set_realization.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def update
    respond_to do |format|
      if @exercise_set_realization.update(exercise_set_realization_params)
        format.json { head :no_content }
      else
        format.json { render json: @exercise_set_realization.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    unless check_if_more_exist
      @exercise_set_realization.errors[:base] << t('exercise_set_realization.error.needs_to_have_one_set')
    end

    respond_to do |format|
      if @exercise_set_realization.errors.empty? && @exercise_set_realization.destroy
        format.json { head :no_content }
        format.js
      else
        format.json { render json: @exercise_set_realization.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  # Realization for ExerciseWithSets needs to have at least one set
  # This can't be done in before_destroy, because we need to be able to
  # delete all sets when realization is deleted
  def check_if_more_exist
    @exercise_set_realization.exercise_realization.exercise_set_realizations.count>1
  end

  # Update row order int for given exercise step, called via Ajax
  def update_row_order
    #authorize! :edit_realizations(plans?), @exercise_step.exercise
    puts exercise_set_realization_params
    @exercise_set_realization.update_attribute :order_position, exercise_set_realization_params[:order_position]
    render nothing: true
  end

  # List exercise setups with filtering enabled
  def list_exercise_set_setups
    @filterrific_setups = initialize_filterrific(
        ExerciseSetup,
        params[:filterrific_setups],
        :select_options => {
            sorted_by: ExerciseSetup.options_for_sorted_by
        }
    ) or return
    er_id = params[:id].blank? ? params[:filterrific_setups][:id] : params[:id]
    exercise = ExerciseSetRealization.find(er_id).exercise_realization.exercise
    # I chose to exclude required exercise steps, realizations for these are added when
    # the realization is created and cant be removed, because they are required
    # If it is needed to add required setups more than once, a special "required" boolean should be added to the realization
    @exercise_set_setups = @filterrific_setups.find.for_exercise(exercise).except_required.type('set_setups').uniq.page(params[:page_s]).per(3)
  end

  def list_exercise_set_realization_setups
    @exercise_set_realization_setups = @exercise_set_realization.exercise_set_realization_setups
  end

  def edit_set_setups
    list_exercise_set_setups
    list_exercise_set_realization_setups
  end

  private
  def set_exercise_set_realization
    @exercise_set_realization = ExerciseSetRealization.find(params[:id])
  end
  # Never trust parameters from the scary internet, only allow the white list through.
  def exercise_set_realization_params
    params.require(:exercise_set_realization).permit(:exercise_realization_id, :order_position,
                                                 :note, :completed,
                                                 :duration_partial_minutes, :duration_partial_seconds,
                                                 :rest_partial_minutes, :rest_partial_seconds)
  end
end
