module ExerciseBundlesHelper
  # Provide edit link with or without warning depending on included exercises
  def edit_button(exercise_bundle, raw_text)
    exercises = exercise_bundle.exercises
    if exercises.blank?
      link_to raw_text, edit_exercise_bundle_path(exercise_bundle), {class: 'btn btn-warning edit-action'}
    else
      link_to raw_text, '#', {class: 'btn btn-warning edit-action', 'data-toggle' => 'modal', 'data-target' => '#warning', 'data-id' => exercise_bundle.id}
    end
  end
end