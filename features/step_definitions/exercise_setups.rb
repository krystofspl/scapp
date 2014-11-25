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

Then(/^I shouldn't see "([^"]*)" checkbox$/) do |arg|
  page.should_not have_css("input##{arg}")
end

When(/^I click "([^"]*)" for "([^"]*)" exercise setup$/) do |arg1, arg2|
  within('#exercise_setups', :text => arg2) do
    click_link(arg1)
  end
end

Then(/^Link "([^"]*)" for "([^"]*)" exercise setup should be disabled$/) do |link, setup|
  find(:xpath, "//div[@class='box'][contains(.,'#{setup}')]//a", :text => link)[:class].include?('disabled')
end

And(/^I should see "([^"]*)" in "([^"]*)"$/) do |what, id|
  find("##{id}").should have_content what
end