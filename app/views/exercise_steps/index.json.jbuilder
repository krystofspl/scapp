json.array!(@exercise_steps) do |exercise_step|
  json.extract! exercise_step, :name, :description, :step_number, :exercise_id
  json.url exercise_step_url(exercise_step, format: :json)
end
