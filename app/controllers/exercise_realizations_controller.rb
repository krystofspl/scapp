class ExerciseRealizationsController < ApplicationController
  # GET /exercise_measurements/1/edit
  def index
    @exercise = Exercise.friendly.find([params[:exercise_code],params[:exercise_version]])
    @exercise_realizations = ExerciseRealization.where(:exercise_code=>params[:exercise_code], :exercise_version=>params[:exercise_version])
  end
end
