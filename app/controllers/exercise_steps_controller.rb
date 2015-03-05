class ExerciseStepsController < ApplicationController
  before_action :set_exercise_step, only: [:edit,:destroy]
  before_action :set_exercise_steps, only: [:index, :edit, :create, :update]
  before_action :set_exercise, only: [:index, :edit, :create, :update]

  def index
    authorize! :index, ExerciseStep
    @exercise_step = ExerciseStep.new
  end

  def new
    authorize! :add_steps, @exercise
    @exercise_step = ExerciseStep.new
  end

  def edit
    authorize! :edit_steps, @exercise
    render :index
  end

  def create
    authorize! :add_steps, @exercise
    @exercise_step = ExerciseStep.new(exercise_step_params)
    @exercise_step.update_attribute :row_order_position, 10000
    respond_to do |format|
      if @exercise_step.save
        upload_images
        format.html { redirect_to :exercise_steps, notice: t('exercise_steps.successfully_added') }
        format.json { render action: 'index', status: :created, location: @exercise_step }
      else
        format.html {
          render :index
        }
        format.json { render json: @exercise_step.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize! :edit_steps, @exercise
    @exercise_step = ExerciseStep.find(exercise_step_params[:exercise_step_id])
    respond_to do |format|
      if @exercise_step.update(exercise_step_params.except(:exercise_step_id))
        upload_images
        format.html { redirect_to exercise_steps_url, notice: t('exercise_steps.successfully_updated') }
        format.json { head :no_content }
      else
        format.html {
          render :index
        }
        format.json { render json: @exercise_step.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize! :destroy, @exercise_step
    @exercise_step.destroy
    respond_to do |format|
      format.html { redirect_to exercise_steps_url, notice: t('exercise_steps.successfully_deleted') }
      format.json { head :no_content }
    end
  end

  # Update row order int for given exercise step, called via Ajax
  def update_row_order
    @exercise_step = ExerciseStep.find(params[:exercise_step][:exercise_step_id])
    authorize! :edit_steps, @exercise_step.exercise
    @exercise_step.update_attribute :row_order_position, exercise_step_params[:row_order_position]

    render nothing: true
    # this is a POST action, updates are sent via AJAX, no view rendered
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exercise_step
      @exercise_step = ExerciseStep.find(params[:exercise_step_id])
    end

    def set_exercise
      @exercise = Exercise.friendly.find([params[:exercise_code],params[:exercise_version].nil? ? 1 : params[:exercise_version]])
    end

    def set_exercise_steps
      @exercise_steps = ExerciseStep.rank(:row_order).where(:exercise_code => params[:exercise_code], :exercise_version => params[:exercise_version].nil? ? 1 : params[:exercise_version])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exercise_step_params
      params.require(:exercise_step).permit(:exercise_step_id, :name, :description, :row_order_position, :exercise_code, :exercise_version)
    end

    def upload_images
      if params[:images_right]
        params[:images_right].each { |image|
          img = ExerciseImage.create(image: image, correctness: :right)
          @exercise_step.exercise_images << img
        }
      end
      if params[:images_wrong]
        params[:images_wrong].each { |image|
          img = ExerciseImage.create(image: image, correctness: :wrong)
          @exercise_step.exercise_images << img
        }
      end
    end
end
