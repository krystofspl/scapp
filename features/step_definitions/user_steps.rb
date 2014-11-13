require_relative 'utility_methods'

### GIVEN ###
Given /^I am not logged in$/ do
  visit '/sign_out'
end

Given /^I am logged in$/ do
  create_user(1)
  sign_in(1)
end

Given /^I exist as a user$/ do
  create_user(1)
end

Given /^I do not exist as a user$/ do
  create_visitor(1)
  delete_user(1)
end

Given /^I exist as an unconfirmed user$/ do
  create_unconfirmed_user(1)
end

Given(/^I am logged in as User test(\d+)$/) do |id|
  sign_in(id.to_i)
end

### WHEN ###
When /^I sign in with valid credentials$/ do
  create_visitor(1)
  sign_in(1)
end

When /^I sign out$/ do
  visit '/sign_out'
end

When /^I sign up with valid user data$/ do
  create_visitor(1)
  sign_up(1)
end

When /^I sign up with an invalid email$/ do
  create_visitor(1)
  @visitor[1] = @visitor[1].merge(:email => "notanemail")
  sign_up(1)
end

When /^I sign up without a password confirmation$/ do
  create_visitor(1)
  @visitor[1] = @visitor[1].merge(:password_confirmation => "")
  sign_up(1)
end

When /^I sign up without a password$/ do
  create_visitor(1)
  @visitor[1] = @visitor[1].merge(:password => "")
  sign_up(1)
end

When /^I sign up with a mismatched password confirmation$/ do
  create_visitor(1)
  @visitor[1] = @visitor[1].merge(:password_confirmation => "changeme123notmatch")
  sign_up(1)
end

When /^I return to the site$/ do
  visit '/dashboard'
end

When /^I sign in with a wrong email$/ do
  @visitor[1] = @visitor[1].merge(:email => "wrong@example.com")
  sign_in(1)
end

When /^I sign in with a wrong password$/ do
  @visitor[1] = @visitor[1].merge(:password => "wrongpass")
  sign_in(1)
end

When /^I edit my account details$/ do
  visit '/users/test1/edit'
  fill_in "Name", :with => "newname"
  fill_in "user_current_password", :with => @visitor[1][:password]
  click_button "Update"
end

When /^I look at the list of users$/ do
  visit '/users'
end

### THEN ###
Then /^I should be signed in$/ do
  page.should have_content "Sign out"
  page.should_not have_content "Sign up"
  page.should_not have_content "Login"
end

Then /^I should be signed out$/ do
  page.should have_content "Sign up"
  page.should have_content "Sign me in"
  page.should_not have_content "Sign out"
end

Then /^I see an unconfirmed account message$/ do
  page.should have_content "You have to confirm your account before continuing."
end

Then /^I see a successful sign in message$/ do
  page.should have_content "Signed in successfully."
end

Then /^I should see a successful sign up message$/ do
  page.should have_content "Welcome! You have signed up successfully."
end

Then /^I should see an invalid email message$/ do
  page.should have_content "is invalid"
end

Then /^I should see a missing password message$/ do
  page.should have_content "Passwordcan't be blank"
end

Then /^I should see a missing password confirmation message$/ do
  page.should have_content "doesn't match"
end

Then /^I should see a mismatched password message$/ do
  page.should have_content "doesn't match"
end

Then /^I should see a signed out message$/ do
  page.should have_content "Signed out successfully."
end

Then /^I see an invalid login message$/ do
  page.should have_content "Invalid email or password."
end

Then /^I should see an account edited message$/ do
  page.should have_content "User profile successfully updated."
end

Then /^I should see my name$/ do
  create_user(1)
  page.should have_content @user[1][:name]
end
When(/^User test(\d+) exists$/) do |id|
  create_user(id.to_i)
end

Then(/^I click "([^"]*)"$/) do |link_text|
  click_link_or_button link_text
end


And(/^I fill in all required user fields$/) do |table|
  # table is a table.hashes.keys # => [:name, :email, :locale]
  values = table.hashes.first

  fill_in 'user_name', with: values[:name]
  fill_in 'user_email', with: values[:email]
  select values[:locale], from: 'user_locale_id'
end

When(/^I click New user button$/) do
  within find('#action-box') do
    click_link 'New user'
  end
end

And(/^User "([^"]*)" has "([^"]*)" role$/) do |user_name, role|
  user = User.friendly.find(user_name)
  user.add_role(role.to_sym)
end

When(/^I select following roles "([^"]*)"$/) do |roles|
  roles.split(',').each do |r|
    role = r.strip

    select role, from: 'Roles'
  end
end

And(/^Global role "([^"]*)" exist in the system$/) do |role|
  Role.find_or_create_by(name: role)
end
