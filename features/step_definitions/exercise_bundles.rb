When(/^I fill in all required fields for exercise_bundle$/) do |table|
  # table is a table.hashes.keys # => [:name, :description]
  values = table.hashes.first
  fill_in 'exercise_bundle_name', with: values[:name]
  fill_in 'exercise_bundle_description', with: values[:description]
end

And(/^Following exercise bundles exist in the system$/) do |table|
  # table is a table.hashes.keys # => [:code, :name, :description, :accessibility, :owner, :exercise]
  table.hashes.each do |t|
    eb = ExerciseBundle.create({:code=>t[:code],:name=>t[:name],:description=>t[:description],:user=>User.friendly.find(t[:owner]), :accessibility=>t[:accessibility]})
    unless t[:exercise].blank?
      Exercise.friendly.find([t[:exercise],1]).exercise_bundles << eb
    end
  end
end
Then(/^Table row for "([^"]*)" should have "([^"]*)" background$/) do |exc, color|
  case color
    when "green"
      css="included"
    when "red"
      css="not-included"
  end
  find(:xpath, "//table[@id='exercises']//tr[contains(.,'#{exc}')]")[:class].include?(css)
end

And(/^Exercise bundle "([^"]*)" contains "([^"]*)" exercise$/) do |bundle, exc|
  eb = ExerciseBundle.friendly.find(bundle)
  eb.exercises << Exercise.friendly.find([exc,1])
end

Then(/^I should see a warning alert message$/) do
  page.find('#btn-continue')
end

When(/^I confirm warning alert message$/) do
  page.find('#btn-continue').click
end

When(/^I fill in all required fields for exercise bundle$/) do |table|
  # table is a table.hashes.keys # => [:name, :description]
  values = table.hashes.first
  fill_in 'exercise_bundle_name', with: values[:name]
  fill_in 'exercise_bundle_description', with: values[:description]
end