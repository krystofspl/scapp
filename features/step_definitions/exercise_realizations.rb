When(/^I drag and drop exercise "(.*)" to plan for user "(.*)"$/) do |exercise_name, user_slug|
  # Krkolomne je to schvalne, protoze krkolomne bohuzel pouzite technologie
  # v tomto pripade funguji (drag&drop+selenium+capybara)
  user_id = User.friendly.find(user_slug).id
  plan = page.find_by_id('player-'+user_id.to_s)
  target = plan.first('.realization')
  dragged_item = page.first('li[data-exercise-code="'+exercise_name.to_s+'"]')
  dragged_item.drag_to(target)
end

Then(/^I should see realization "(.*)" in the plan for user "(.*)"$/) do |what, user_slug|
  user_id = User.friendly.find(user_slug).id
  expect(page).to have_css('#player-'+user_id.to_s+' li', :text=> what)
end

And(/^Following exercise realizations exist in the system$/) do |table|
  # table is a table.hashes.keys # => [:exercise, :user_created, :user_partook]
  # Create plans
  TrainingLessonRealization.first.attendances.each do |att|
    plan = Plan.new
    plan.user_created = User.friendly.find(table.hashes.first[:user_created])
    plan.user_partook = User.friendly.find(att.user.id)
    plan.training_lesson_realization = att.training_lesson_realization
    plan.save!
  end
  # Create realizations
  table.hashes.each_with_index do |r,index|
    er = ExerciseRealization.new
    er.exercise = Exercise.friendly.find([r[:exercise],1])
    er.user_created = User.friendly.find(r[:user_created])
    er.row_order = index
    er.plan = Plan.where(:user_partook => User.friendly.find(r[:user_partook]).id).first
    er.save!
  end
end

When(/^I click Edit for exercise realization "(.*)" in plan for user "(.*)"$/) do |exercise, user|
  plan = Plan.where("user_partook_id=?",User.friendly.find(user).id).first
  realization_id = plan.exercise_realizations.where("exercise_code=?",exercise).first.id
  li = find("li[data-realization-id='"+realization_id.to_s+"']")
  li.hover
  li.find(".btn-edit", :visible => false).click
end

When(/^I click Delete for exercise realization "(.*)" in plan for user "(.*)"$/) do |exercise, user|
  plan = Plan.where("user_partook_id=?",User.friendly.find(user).id).first
  realization_id = plan.exercise_realizations.where("exercise_code=?",exercise).first.id
  li = find("li[data-realization-id='"+realization_id.to_s+"']")
  li.hover
  li.find(".btn-destroy", :visible => false).click
end


When(/^I fill in the realization edit form$/) do |table|
  # table is a table.hashes.keys # => [:Dhours, :Dminutes, :Dseconds, :Rminutes, :Rseconds, :note]
  table.hashes.each do |t|
    fill_in 'exercise_realization_duration_partial_hours', with: t[:Dhours]
    fill_in 'exercise_realization_duration_partial_minutes', with: t[:Dminutes]
    fill_in 'exercise_realization_duration_partial_seconds', with: t[:Dseconds]
    fill_in 'exercise_realization_rest_partial_minutes', with: t[:Rminutes]
    fill_in 'exercise_realization_rest_partial_seconds', with: t[:Rseconds]
    fill_in 'exercise_realization_note', with: t[:note]
  end
end

Then(/^I should see "([^"]*)" in realization "([^"]*)" in plan for user "([^"]*)"$/) do |what, exercise, user|
  plan = Plan.where("user_partook_id=?",User.friendly.find(user).id).first
  realization_id = plan.exercise_realizations.where("exercise_code=?",exercise).first.id
  find("li[data-realization-id='"+realization_id.to_s+"'] .realization-duration").should have_content(what)
end

Then(/^I should see an error message in the form containing "([^"]*)"$/) do |arg|
  find(".form-errors li").should have_content(arg)
end

Then(/^I should see "([^"]*)" realization at position n\. "([^"]*)"$/) do |exc, pos|
  expect(page.all(".realization")[pos.to_i-1]).to have_content(exc)
end

When(/^I move "([^"]*)" realization one step down$/) do |arg|
  page.execute_script %{
    $('.realization:contains("#{arg}")').simulateDragSortable({move: 1});
      }
end

Then(/^I should not see realization "([^"]*)" in plan for user "([^"]*)"$/) do |realization, user|
  user_id = User.friendly.find(user).id
  expect(page.find_by_id('player-'+user_id.to_s)).to_not have_content(realization)
end