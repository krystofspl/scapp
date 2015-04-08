accordion = "ul[id='exercise-set-realization-setups-accordion']"

And(/^Following exercise set realization setups exist in the system$/) do |table|
  # table is a table.hashes.keys # => [:exercise, :exercise_setup, :value]
  table.hashes.each do |t|
    e = ExerciseSetRealizationSetup.new(:exercise_set_realization=>ExerciseRealization.where(:exercise_code=>t[:exercise]).first.exercise_set_realizations.first, :exercise_setup_code=>t[:exercise_setup])
    t[:value].is_number? ? e.numeric_value=t[:value] : e.string_value=t[:value]
    e.save!
  end
end

Then(/^I should see an exercise set realization setup "([^"]*)"$/) do |setup|
  expect(find(accordion)).to have_selector("li", :text => setup)
end

Then(/^I shouldn't see an exercise set realization setup "([^"]*)"$/) do |setup|
  expect(find(accordion)).to_not have_selector("li", :text => setup)
end

Then(/^I shouldn't see "([^"]*)" button for exercise set realization setup "([^"]*)"$/) do |btn, setup|
  li = find(accordion).find("li", :text=>setup)
  li.hover
  expect(li).to_not have_css(".btn", :text=>btn)
end

When(/^I click "([^"]*)" for exercise set realization setup "([^"]*)"$/) do |btn, setup|
  li = find(accordion).find("li", :text=>setup)
  li.hover
  li.find(".btn", :text=>btn).click
end

When(/^I click Add for exercise set setup "([^"]*)"$/) do |setup|
  li = find("li", :text => setup)
  li.hover
  li.find(".btn-add", :visible => false).click
end

When(/^I fill in exercise set realization setup fields$/) do |table|
  # table is a table.hashes.keys # => [:value, :note]
  table.hashes.each do |t|
    fill_in 'exercise_set_realization_setup_numeric_value', with: t[:value]
    fill_in 'exercise_set_realization_setup_note', with: t[:note]
  end
end

Then(/^I should see an exercise set realization setup "([^"]*)" with text "([^"]*)"$/) do |setup, text|
  expect(find(accordion).find("li",:text => setup)).to have_content(text)
end