module ExercisesHelper
  # Provide edit link with or without warning depending on included exercises
  def edit_button_exercise(exercise, raw_text)
    if exercise.is_in_use?
      link_to raw_text, '#', {class: 'btn btn-warning edit-action', 'data-toggle' => 'modal', 'data-target' => '#warning', 'data-id' => exercise.relative_url}
    else
      link_to raw_text, exercise.url+'/edit', {class: 'btn btn-warning edit-action'}
    end
  end

  ######### Hopefully a temporary override of default paths,
  ######### Rails 4.2 doesn't support adding optional parameters to links,
  ######### so everything with exercise version has to be modified,
  ######### https://github.com/rails/rails/issues/7047

  # Override default exercise path method with custom URL
  def exercise_path(exercise, params = {})
    exercise.url
  end
end