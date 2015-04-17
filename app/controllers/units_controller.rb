class UnitsController < ApplicationController
  before_action :set_unit, only: [:show, :edit, :update, :destroy]
  before_action :set_units, only: [:index]

  def index
    authorize! :index, Unit
  end

  def show
    authorize! :show, @unit
  end

  def new
    authorize! :create, Unit
    @unit = Unit.new
  end

  def edit
    authorize! :edit, @unit
  end

  def create
    authorize! :create, Unit
    @unit = Unit.new(unit_params)

    respond_to do |format|
      if @unit.save
        format.html { redirect_to units_url, notice: 'Unit was successfully created.' }
        format.json { render action: 'index', status: :created, location: units_url}
      else
        format.html { render action: 'new' }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize! :edit, Unit
    respond_to do |format|
      if @unit.update(unit_params)
        format.html { redirect_to units_url, notice: 'Unit was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end

  end

  def destroy
    authorize! :destroy, @unit
    @unit.destroy
    respond_to do |format|
      format.html { redirect_to units_url, notice: 'Unit was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unit
      @unit = Unit.friendly.find(params[:id])
    end

    def set_units
      @units = Unit.all
    end

    # Never trust parameters from the scary internet, only allow the white index through.
    def unit_params
      params.require(:unit).permit(:code,:name,:abbreviation,:unit_type)
    end
end