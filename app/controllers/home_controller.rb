class HomeController < ApplicationController

  def index
    authorize! :index, HomeController

    @regular_trainings = RegularTraining.public_available.page(params[:training_page])

    render :layout => 'application_public'
  end

  def dashboard
    authorize! :dashboard, HomeController

    # COMMON #######################
    # closest trainings for user
    @closest_training_lessons = TrainingLessonRealization.closest_lesson_realizations(current_user)
    @closest_training_lessons = @closest_training_lessons.includes(:attendances)

    # WATCHER SPECIFIC ############
    # close trainings of watched players
    if is_watcher?
      @closest_training_lessons_watched = TrainingLessonRealization.closest_watched_lesson_realizations(current_user)

      # get connected players I watch
      @my_connected_wards = current_user.get_my_relations_with_statuses 'accepted', :my_wards

      # get latest measurements of my wards
      @latest_measurements_of_my_wards = VariableFieldMeasurement.latest_for_watched_players_by(current_user, 10)
    end

    # PLAYER SPECIFIC ##############
    if is_player?
      @my_latest_vf_measurements = VariableFieldMeasurement.latest_for_user(current_user, 5)
      @my_connected_coaches = current_user.get_my_relations_with_statuses 'accepted', :my_coaches
    end

    # COACH SPECIFIC ##############
    if is_coach?
      # get closest training realizations I am coaching
      @closest_trained_by_me = TrainingLessonRealization.closest_trained_by_user(current_user).includes(:attendances)

      # get latest measurements of my players
      @latest_measurements_of_my_players = VariableFieldMeasurement.latest_for_coached_players_by(current_user, 10)
    end

    # ADMIN SPECIFIC ###############
    if is_admin?

    end

  end
end
