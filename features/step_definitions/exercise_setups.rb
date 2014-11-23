When(/^I fill in all required exercise setup fields$/) do |table|
  # table is a table.hashes.keys # => [:name, :description]
  values = table.hashes.first

  fill_in 'exercise_setup_name', with: values[:name]
  fill_in 'exercise_setup_description', with: values[:description]
end

And(/^Following exercise setups exist in the system$/) do |table|
  # table is a table.hashes.keys # => [:name, :description, :required, :unit, :exercise]
  table.hashes.each do |t|
    ExerciseSetup.create(:name=>t[:name],:description=>t[:description],:required=>t[:required],:unit_code=>Unit.friendly.find(t[:unit]),:exercise_code=>t[:exercise],:exercise_version=>1)
  end
end

And(/^Exercise setup "([^"]*)" is in use$/) do |arg|
    exerciseS = ExerciseSetup.where(:name => arg).first
    exerciseRealizationS = ExerciseRealizationSetup.new
    exerciseRealizationS.exercise_setup = exerciseS
    exerciseRealizationS.save
    exerciseS.save
end

And(/^Exercise setup "([^"]*)" is not in use$/) do |arg|
  exerciseS = ExerciseSetup.where(:name => arg).first
  unless exerciseS.exercise_realization_setups.empty?
    exerciseS.exercise_realization_setups.each do |s|
      s.delete
    end
  end
end