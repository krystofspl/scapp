And(/^Following exercises exist in the system$/) do |table|
  # table is a table.hashes.keys # => [:code, :name, :description, :accessibility, :owner]
  table.hashes.each do |r|
    user = User.friendly.find(r[:owner])
    Exercise.create({name: r[:name], description: r[:description], accessibility: r[:accessibility], user: user})
  end
end

And(/^Exercise "([^"]*)" is in use$/) do |arg|
  exercise = Exercise.where(:name => arg).first
  exerciseRealization = ExerciseRealization.new
  exerciseRealization.exercise = exercise
  exerciseRealization.save
  exercise.save
end

And(/^Exercise "([^"]*)" is not in use$/) do |arg|
  # don't need to do anything, it is not in use by default
end

When(/^I fill in all required fields for exercise$/) do |table|
  # table is a table.hashes.keys # => [:name, :description, :type]
  values = table.hashes.first

  fill_in 'exercise_name', with: values[:name]
  fill_in 'exercise_description', with: values[:description]
  select values[:type], from: 'exercise_type'
end

And(/^Radio button "([^"]*)" should be selected$/) do |arg|
  page.should have_checked_field(arg)
end