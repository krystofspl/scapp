And(/^Following exercises exist in the system$/) do |table|
  # table is a table.hashes.keys # => [:name, :description, :accessibility, :owner, :type]
  table.hashes.each do |r|
    user = User.friendly.find(r[:owner])
    exercise_type = r[:type].blank? ? 'Exercise' : r[:type]
    Exercise.create({name: r[:name], description: r[:description], accessibility: r[:accessibility], user: user, type: exercise_type})
  end
end

And(/^Exercise "([^"]*)" is in use$/) do |arg|
  exercise = Exercise.where(:name => arg).first
  er = ExerciseRealization.new
  er.exercise = exercise
  er.plan = Plan.create()
  er.user_created = User.first
  er.order = 0
  er.save!
end

And(/^Exercise "([^"]*)" is not in use$/) do |arg|
  # don't need to do anything, it is not in use by default
end

When(/^I fill in all required fields for exercise$/) do |table|
  # table is a table.hashes.keys # => [:name, :description, :type]
  values = table.hashes.first

  fill_in 'exercise_name', with: values[:name]
  fill_in 'exercise_description', with: values[:description]
  #select values[:type], from: 'exercise_type'
end

And(/^Radio button "([^"]*)" should be selected$/) do |arg|
  page.should have_checked_field(arg)
end

And(/^Following exercise steps exist in the system$/) do |table|
  # table is a table.hashes.keys # => [:name, :description, :step_number, :exercise]
  table.hashes.each do |r|
    exercise = Exercise.friendly.find([r[:exercise],1])
    ExerciseStep.create({name: r[:name], description: r[:description], row_order: r[:step_number], exercise: exercise})
  end
end

And(/^Exercise step "([^"]*)" should have number "([^"]*)"$/) do |arg1, arg2|
  step0 = ExerciseStep.where(:name=>arg1).first
  exc = step0.exercise
  steps = exc.exercise_steps
  steps.index(step0).should eq(((arg2.to_i)-1))
end


When(/^I fill all required fields for exercise step$/) do |table|
  # table is a table.hashes.keys # => [:name, :description]
  values = table.hashes.first

  fill_in 'exercise_step_name', with: values[:name]
  fill_in 'exercise_step_description', with: values[:description]
end

Then(/^I should see an exercise fork dialog$/) do
  expect(page).to have_css('#btn-continue')
end

Then(/^I shouldn't see "([^"]*)" tab$/) do |tab|
  expect(page).to_not have_content(tab)
end

When(/^I choose to edit the current version$/) do
  page.find('#btn-continue').click
end

When(/^I choose to make a new version$/) do
  page.find('#btn-clone').click
end

When(/^I click "([^"]*)" tab$/) do |link_text|
  click_link_or_button link_text
end

