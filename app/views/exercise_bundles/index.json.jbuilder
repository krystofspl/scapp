json.array!(@exercise_bundles) do |exercise_set|
  json.extract! exercise_set, :code, :name, :description, :accessibility, :user_id
  json.url exercise_set_url(exercise_set, format: :json)
end
