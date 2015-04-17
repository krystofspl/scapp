class FavoritePlansController < ApplicationController
  before_action :set_plan, only: [:new, :create, :copy_favorite_to_plan]
  before_action :set_favorite_plan, only: [:destroy, :copy_favorite_to_plan]

  def index
    @favorite_plans = FavoritePlan.where(:user=>current_user).page(params[:page]).per(5)
  end

  def new
    @favorite_plan = FavoritePlan.new(favorite_plan_params)
  end

  def create
    @favorite_plan = FavoritePlan.new(favorite_plan_params)
    cloned = @plan.deep_clone
    cloned.user_created = current_user
    cloned.save
    @favorite_plan.plan = cloned
    @favorite_plan.user = current_user
    respond_to do |format|
      if @favorite_plan.save
        format.json { head :no_content }
      else
        cloned.destroy
        format.json { render json: @favorite_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @favorite_plan.destroy
        format.json { head :no_content }
      else
        format.json { render json: @favorite_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  def copy_favorite_to_plan
    position = params[:new_position].nil? ? 0 : params[:new_position].to_i
    respond_to do |format|
      if @favorite_plan.plan.duration <= @plan.remaining_time
        ActiveRecord::Base.transaction do
          @favorite_plan.plan.exercise_realizations.rank(:row_order).each_with_index do |realization, index|
            realization.deep_clone(@plan, position+index)
          end
        end
        format.json { head :no_content }
      else
        @favorite_plan.errors[:base] << t('favorite_plan.error.too_long_for_plan')
        format.json { render json: @favorite_plan.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_plan
      @plan = Plan.find(favorite_plan_params[:plan_id])
    end

    def set_favorite_plan
      @favorite_plan = FavoritePlan.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white index through.
    def favorite_plan_params
      params.require(:favorite_plan).permit(:plan_id, :name, :note, :new_position)
    end
end