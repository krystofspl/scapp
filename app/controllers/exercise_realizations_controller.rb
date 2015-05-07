class ExerciseRealizationsController < ApplicationController
  helper ExerciseRealizationsHelper
  before_action :set_exercise_realization, only: [:edit, :update, :destroy, :update_row_order, :list_exercise_realization_setups, :edit_sets, :list_exercise_set_realizations]
  before_action :set_training_lesson_realization, only: [:index, :list_summary, :create]
  before_filter :check_lesson_closed, except: [:list_summary]

  # Index action here is a page where realizations can be edited,
  # normal index is ExerciseRealizations#list_summary
  def index
    authorize! :edit_plans, @training_lesson_realization
    create_plans_for_users #TODO Move this to where attendance is created
    list_exercises
  end

  # Read-only list with all accessible plans
  def list_summary
    authorize! :list_plans, @training_lesson_realization
    @plans = @training_lesson_realization.plans.accessible(@training_lesson_realization,current_user)
  end

  def show_short
    @exercise_realization = ExerciseRealization.find(params[:realization_id])
    render partial: 'exercise_realizations/detail_short', locals: {realization: @exercise_realization}
  end

  def create
    authorize! :edit_plans, @training_lesson_realization
    @exercise_realization = ExerciseRealization.new(exercise_realization_params)
    @exercise_realization.user_created = current_user
    @exercise_realization.plan = Plan.find(exercise_realization_params[:plan_id])
    @exercise_realization.time_duration = 60 unless @exercise_realization.exercise.has_sets?
    respond_to do |format|
      if @exercise_realization.save
        # Set order position for the realization
        @exercise_realization.update_attribute :row_order_position, exercise_realization_params[:order]
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
        format.js # JS template
      else
        format.json { render json: @exercise_realization.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  # Update row order int for given exercise step, called via Ajax
  def update_row_order
    authorize! :edit, @exercise_realization
    @exercise_realization.update_attribute :row_order_position, exercise_realization_params[:row_order_position]
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

  ### LIST PARTIALS
  
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
    # js.erb partial is rendered
  end

  def list_exercise_set_realizations
    @exercise_set_realizations = @exercise_realization.exercise_set_realizations.rank(:row_order)
    # js.erb partial is rendered
  end

  def edit_setups
    list_exercise_setups
    # js.erb partial is rendered
  end

  def edit_sets
    list_exercise_set_realizations
    # js.erb partial is rendered
  end

  private
    def set_exercise_realization
      @exercise_realization = ExerciseRealization.find(params[:id])
    end

    def set_training_lesson_realization
      @training_lesson_realization = TrainingLessonRealization.friendly.find(params[:training_lesson_realization_id])
    end

    # Never trust parameters from the scary internet, only allow the white index through.
    def exercise_realization_params
      params.require(:exercise_realization).permit(:exercise_code, :exercise_version, :row_order_position, :plan_id,
                                                   :note, :completed, :user_created_id,
                                                   :user_measured_id,
                                                   :duration_partial_hours, :duration_partial_minutes, :duration_partial_seconds,
                                                   :rest_partial_minutes, :rest_partial_seconds)
    end

    #TODO this will be moved after plan is connected to attendance (planned fix)
    def create_plans_for_users
      @training_lesson_realization.attendances.each do |attendance|
        unless Plan.where(:training_lesson_realization_id => @training_lesson_realization.id).where(:user_partook => attendance.user).any?
          plan = Plan.new(:user_created=>current_user, :user_partook=>attendance.user,:training_lesson_realization=>@training_lesson_realization)
          plan.save
        end
      end
    end

    # Redirect to TLR with error if it has been closed
    def check_lesson_closed
      @training_lesson_realization = TrainingLessonRealization.friendly.find(params[:training_lesson_realization_id])
      if @training_lesson_realization.closed?
        flash[:error] = t('exercise_realizations.error.lesson_has_been_closed')
        redirect_to @training_lesson_realization
      end
    end
end
