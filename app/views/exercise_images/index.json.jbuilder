json.array!(@exercise_images) do |exercise_image|
  json.extract! exercise_image, :name, :path, :description, :correctness, :exercise_phase_id, :exercise_id
  json.url exercise_image_url(exercise_image, format: :json)
end
