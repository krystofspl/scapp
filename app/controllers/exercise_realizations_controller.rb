class ExerciseRealizationsController < ApplicationController
  before_action :set_exercise_realization, only: [:edit, :update, :destroy, :list_exercise_realization_setups]
  def index
    @training_lesson_realization = TrainingLessonRealization.friendly.find(params[:training_lesson_realization_id])
    #TODO presunout nekam, kde se to nebude volat tak casto?
    @training_lesson_realization.attendances.each do |attendance|
      unless Plan.where(:training_lesson_realization_id => @training_lesson_realization.id).where(:user_partook => attendance.user).any?
        create_plan_for_user(attendance.user)
      end
    end
    list_exercises
  end

  def show_short
    @exercise_realization = ExerciseRealization.find(params[:realization_id])
    render partial: 'exercise_realizations/detail_short', locals: {realization: @exercise_realization}
  end

  def create
    @exercise_realization = ExerciseRealization.new(exercise_realization_params)
    @exercise_realization.user_created = current_user
    @exercise_realization.plan = Plan.find(exercise_realization_params[:plan_id])
    @exercise_realization.update_attribute :order_position, exercise_realization_params[:order]
    respond_to do |format|
      if @exercise_realization.save!
        format.json { render :json => @exercise_realization}
      else
        format.json { render json: @exercise_realization.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def update
    respond_to do |format|
      if @exercise_realization.update(exercise_realization_params)
        format.json { head :no_content }
      else
        format.json { render json: @exercise_realization.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @exercise_realization.destroy
    respond_to do |format|
      format.html { redirect_to training_lesson_realization_exercise_realizations_path }
      format.json { head :no_content }
      format.js   { render :layout => false }
    end
  end

  # Update row order int for given exercise step, called via Ajax
  def update_row_order
    @exercise_realization = ExerciseRealization.find(exercise_realization_params[:id])
    #authorize! :edit_realizations(plans?), @exercise_step.exercise
    @exercise_realization.update_attribute :order_position, exercise_realization_params[:order_position]
    render nothing: true
    # this is a POST action, updates are sent via AJAX, no view rendered
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
    #TODO následující query je asi neoptimální
    @exercises = @filterrific.find.accessible(current_user).uniq.page(params[:page]).per(3)
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
    exercise_id = params[:id].blank? ? params[:filterrific_setups][:id] : params[:id]
    exercise = ExerciseRealization.find(exercise_id).exercise
    #TODO následující query je asi neoptimální
    # I chose to exclude required exercise steps, realizations for these are added when
    # the realization is created and cant be removed, because they are required
    # If it is needed to add required setups more than once, a special "required" boolean should be added to the realization
    @exercise_setups = @filterrific_setups.find.for_exercise(exercise).except_required.uniq.page(params[:page_s]).per(3)
  end

  def list_exercise_realization_setups
    @exercise_realization_setups = @exercise_realization.exercise_realization_setups
  end

  def edit_setups
    list_exercise_setups
  end

  private
    def set_exercise_realization
      @exercise_realization = ExerciseRealization.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def exercise_realization_params
      params.require(:exercise_realization).permit(:id, :exercise_code, :exercise_version, :order_position, :plan_id,
                                                   :note, :completed, :user_created_id,
                                                   :user_measured_id,
                                                   :duration_partial_hours, :duration_partial_minutes, :duration_partial_seconds,
                                                   :rest_partial_minutes, :rest_partial_seconds)
    end

    def create_plan_for_user(user)
      plan = Plan.new
      plan.user_created = current_user
      plan.user_partook = user
      plan.training_lesson_realization = @training_lesson_realization
      plan.save
    end
end
