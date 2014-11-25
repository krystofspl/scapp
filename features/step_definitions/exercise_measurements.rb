And(/^Following optimal values exist in the system$/) do |table|
  # table is a table.hashes.keys # => [:name]
  # Exercise measurement optimal values are hardcode-stored as a part of exc. measurement
end

And(/^Following exercise measurements exist in the system$/) do |table|
  # table is a table.hashes.keys # => [:name, :description, :optimal_value, :unit, :exercise]
  table.hashes.each do |t|
    ExerciseMeasurement.create(:name=>t[:name], :description=>t[:description], :optimal_value=>t[:optimal_value], :unit=>Unit.where(:code=>t[:unit]).first, :exercise_code=>t[:exercise], :exercise_version=>1)
  end
end

And(/^Exercise measurement "([^"]*)" is in use$/) do |arg|
  exerciseM = ExerciseMeasurement.where(:name => arg).first
  exerciseRealizationM = ExerciseRealizationMeasurement.new
  exerciseRealizationM.exercise_measurement = exerciseM
  exerciseRealizationM.save
  exerciseM.save
end

And(/^Exercise measurement "([^"]*)" is not in use$/) do |arg|
  # don't need to do anything, it is not in use by default
end

When(/^I fill in all required exercise measurement fields$/) do |table|
  # table is a table.hashes.keys # => [:name, :description]
  values = table.hashes.first

  fill_in 'exercise_measurement_name', with: values[:name]
  fill_in 'exercise_measurement_description', with: values[:description]
end

And(/^I select option "([^"]*)" from the "([^"]*)" menu$/) do |arg1, arg2|
  select arg1, :from => arg2
end

Then(/^Link "([^"]*)" for "([^"]*)" exercise measurement should be disabled$/) do |link, measurement|
  find(:xpath, "//div[@class='box'][contains(.,'#{measurement}')]//a", :text => link)[:class].include?('disabled')
end

When(/^I click "([^"]*)" for "([^"]*)" exercise measurement$/) do |arg1, arg2|
  within('#exercise_measurements', :text => arg2) do
    click_link(arg1)
  end
end