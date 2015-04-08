accordion = "ul[id='exercise-realization-setups-accordion']"

Then(/^I should see an exercise realization setup "([^"]*)"$/) do |setup|
  expect(find(accordion)).to have_selector("li", :text => setup)
end

Then(/^I shouldn't see an exercise realization setup "([^"]*)"$/) do |setup|
  expect(find(accordion)).to_not have_selector("li", :text => setup)
end

Then(/^I should see an exercise realization setup "([^"]*)" with text "([^"]*)"$/) do |setup, text|
  expect(find(accordion).find("li",:text => setup)).to have_content(text)
end

Then(/^I should see an error message near the form$/) do
  expect(find(".form-errors")).to have_content('Following errors occured:')
end

Then(/^I shouldn't see "([^"]*)" button for exercise realization setup "([^"]*)"$/) do |btn, setup|
  li = find(accordion).find("li", :text=>setup)
  li.hover
  expect(li).to_not have_css(".btn", :text=>btn)
end

When(/^I fill in exercise realization setup fields$/) do |table|
  # table is a table.hashes.keys # => [:value, :note]
  table.hashes.each do |t|
    fill_in 'exercise_realization_setup_numeric_value', with: t[:value]
    fill_in 'exercise_realization_setup_note', with: t[:note]
  end
end

And(/^Following exercise realization setups exist in the system$/) do |table|
  # table is a table.hashes.keys # => [:exercise_realization_exercise, :exercise_setup, :value]
  table.hashes.each do |t|
    ExerciseRealizationSetup.create(:exercise_realization=>ExerciseRealization.where(:exercise_code=>t[:exercise_realization_exercise]).first, :exercise_setup=>ExerciseSetup.where(:code=>t[:exercise_setup]).first, :numeric_value=> t[:value])
  end
end

When(/^I click Add for exercise setup "([^"]*)"$/) do |setup|
  li = find("li", :text => setup)
  li.hover
  li.find(".btn-add", :visible => false).click
end

And(/^I click "([^"]*)" for exercise realization setup "([^"]*)"$/) do |btn, setup|
  li = find(accordion).find("li", :text=>setup)
  li.hover
  li.find(".btn", :text=>btn).click
end