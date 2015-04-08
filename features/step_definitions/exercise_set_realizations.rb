sortable_li = "ul[id='exercise-set-realizations-sortable'] li"

Then(/^I should see an exercise set for the realization$/) do
  expect(page).to have_css(sortable_li)
end

And(/^I fill in all required fields for exercise set realization$/) do |table|
  # table is a table.hashes.keys # => [:duration_minutes, :duration_seconds, :rest_minutes, :rest_seconds, :note]
  table.hashes.each do |t|
    fill_in "exercise_set_realization_duration_partial_minutes", with: t[:duration_minutes]
    fill_in "exercise_set_realization_duration_partial_seconds", with: t[:duration_seconds]
    fill_in "exercise_set_realization_rest_partial_minutes", with: t[:rest_minutes]
    fill_in "exercise_set_realization_rest_partial_seconds", with: t[:rest_seconds]
    fill_in "exercise_set_realization_note", with: t[:note]
  end
end

Then(/^I should see an exercise set for the realization with text "([^"]*)"$/) do |text|
  expect(page).to have_css(sortable_li, :text=> text, exact: true)
end

Then(/^I shouldn't see an exercise set for the realization with text "([^"]*)"$/) do |text|
  expect(page).to_not have_css(sortable_li, :text=> text, exact: true)
end

And(/^Following exercise set realizations exist in the system$/) do |table|
  # table is a table.hashes.keys # => [:exercise, :duration]
  table.hashes.each do |t|
    er = ExerciseRealization.where(:exercise_code=>t[:exercise]).first.id
    esr = ExerciseSetRealization.new(:exercise_realization_id=>er, :time_duration=> t[:duration].to_i*60)
    esr.update_attribute :order_position, 10000
    esr.save!
  end
end

Then(/^I should see an error message containing "([^"]*)"$/) do |err|
  expect(page).to have_css("div[id='exercise-set-errors']",:text=>err)
end

When(/^I click "([^"]*)" for exercise set realization with index "([^"]*)"$/) do |btn, index|
  realization = page.find(sortable_li+":nth-of-type("+index+")")
  realization.hover
  realization.find(".btn",:text=>btn).click
end

Then(/^I should see an exercise set realization at position n\. "([^"]*)" with text "([^"]*)"$/) do |index, text|
  expect(page.find(sortable_li+":nth-of-type("+index+")")).to have_content(text)
end

When(/^I move first set realization one step down$/) do
  # Tried :nth-of-type to be more general, but selenium doesn't recognize it somehow
  page.execute_script %{
  $('ul#exercise-set-realizations-sortable li').first().simulateDragSortable({move: 1});
    }
end