class ExerciseRealizationsController < ApplicationController
  helper ExerciseRealizationsHelper
  before_action :set_exercise_realization, only: [:edit, :update, :destroy, :update_row_order, :list_exercise_realization_setups, :edit_sets, :list_exercise_set_realizations]

  # Index action here is a page where realizations can be edited,
  # normal index is ExerciseRealizations#list_summary
  def index
    @training_lesson_realization = TrainingLessonRealization.friendly.find(params[:training_lesson_realization_id])
    authorize! :edit, @training_lesson_realization
    #TODO Move this somewhere else, so that it's not called so often, if possible
    create_plans_for_users
    list_exercises
  end

  def list_summary
    @training_lesson_realization = TrainingLessonRealization.friendly.find(params[:training_lesson_realization_id])
    authorize! :list_summary, @training_lesson_realization
  end

  def show_short
    @exercise_realization = ExerciseRealization.find(params[:realization_id])
    render partial: 'exercise_realizations/detail_short', locals: {realization: @exercise_realization}
  end

  def create
    authorize! :edit, TrainingLessonRealization.friendly.find(params[:training_lesson_realization_id])
    @exercise_realization = ExerciseRealization.new(exercise_realization_params)
    @exercise_realization.user_created = current_user
    @exercise_realization.plan = Plan.find(exercise_realization_params[:plan_id])
    @exercise_realization.time_duration = 60 unless @exercise_realization.exercise.has_sets?
    respond_to do |format|
      if @exercise_realization.save
        # Set order position for the realization
        @exercise_realization.update_attribute :order_position, exercise_realization_params[:order]
        format.json { render :json => @exercise_realization }
      else
        puts @exercise_realization.errors
        format.json { render json: @exercise_realization.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    authorize! :edit, @exercise_realization
    respond_to do |format|
      format.js
    end
  end

  def update
    authorize! :edit, @exercise_realization
    respond_to do |format|
      if @exercise_realization.update(exercise_realization_params)
        format.json { head :no_content }
      else
        format.json { render json: @exercise_realization.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize! :destroy, @exercise_realization
    respond_to do |format|
      if @exercise_realization.destroy
        format.json { head :no_content }
        format.js
      else
        format.json { render json: @exercise_realization.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  # Update row order int for given exercise step, called via Ajax
  def update_row_order
    authorize! :edit, @exercise_realization
    @exercise_realization.update_attribute :order_position, exercise_realization_params[:order_position]
    render nothing: true
  end

  # List exercises with filtering enabled
  def list_exercises
    @filterrific = initialize_filterrific(
        Exercise,
        params[:filterrific],
        :select_options => {
            sorted_by: Exercise.options_for_sorted_by
        }
    ) or return
    @exercises = @filterrific.find.accessible(current_user).uniq.page(params[:page]).per(3)
  end

  # List exercise realizations
  def list_exercise_realizations
    render partial: 'exercise_realizations/list_small', locals: {plan: Plan.find(params[:plan_id])}
  end

  # List exercise setups with filtering enabled
  def list_exercise_setups
    @filterrific_setups = initialize_filterrific(
        ExerciseSetup,
        params[:filterrific_setups],
        :select_options => {
            sorted_by: ExerciseSetup.options_for_sorted_by
        }
    ) or return
    er_id = params[:id].blank? ? params[:filterrific_setups][:id] : params[:id]
    exercise = ExerciseRealization.find(er_id).exercise
    # I chose to exclude required exercise steps, realizations for these are added when
    # the realization is created and cant be removed, because they are required
    # If it is needed to add required setups more than once, a special "required" boolean should be added to the realization
    @exercise_setups = @filterrific_setups.find.for_exercise(exercise).except_required.type('simple_setups').uniq.page(params[:page_s]).per(3)
  end

  def list_exercise_realization_setups
    @exercise_realization_setups = @exercise_realization.exercise_realization_setups
  end

  def list_exercise_set_realizations
    @exercise_set_realizations = @exercise_realization.exercise_set_realizations.rank(:order)
  end

  def edit_setups
    list_exercise_setups
  end

  def edit_sets
    list_exercise_set_realizations
  end

  private
    def set_exercise_realization
      @exercise_realization = ExerciseRealization.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def exercise_realization_params
      params.require(:exercise_realization).permit(:exercise_code, :exercise_version, :order_position, :plan_id,
                                                   :note, :completed, :user_created_id,
                                                   :user_measured_id,
                                                   :duration_partial_hours, :duration_partial_minutes, :duration_partial_seconds,
                                                   :rest_partial_minutes, :rest_partial_seconds)
    end

    def create_plans_for_users
      @training_lesson_realization.attendances.each do |attendance|
        unless Plan.where(:training_lesson_realization_id => @training_lesson_realization.id).where(:user_partook => attendance.user).any?
          plan = Plan.new(:user_created=>current_user, :user_partook=>attendance.user,:training_lesson_realization=>@training_lesson_realization)
          plan.save
        end
      end
    end
end
