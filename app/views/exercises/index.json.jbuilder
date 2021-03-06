json.array!(@exercises) do |exercise|
  json.extract! exercise, :code, :version, :name, :author_name, :description, :sources, :youtube_url, :accessibility, :exercise_type, :user_id, :exercise_image_id
  json.url exercise_url(exercise, format: :json)
end
