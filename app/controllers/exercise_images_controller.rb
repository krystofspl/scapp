class ExerciseImagesController < ApplicationController
  before_action :set_exercise_image, only: [:destroy]

  def create
    @exercise_image = ExerciseImage.new(exercise_image_params)
    @exercise_image.save
  end

  # PATCH/PUT /exercise_images/1
  # PATCH/PUT /exercise_images/1.json
  def update
    respond_to do |format|
      if @exercise_image.update(exercise_image_params)
        format.html { redirect_to @exercise_image, notice: 'Exercise image was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @exercise_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exercise_images/1
  # DELETE /exercise_images/1.json
  def destroy
    @exercise_image.destroy
    redirect_to :back
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exercise_image
      @exercise_image = ExerciseImage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exercise_image_params
      params.require(:exercise_image).permit(:description, :correctness, :exercise_step_id, :exercise_code, :exercise_version)
    end
end
