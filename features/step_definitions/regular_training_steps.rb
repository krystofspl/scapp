And(/^Following regular trainings exist in the system$/) do |table|
  # table is a table.hashes.keys # => [:name, :description, :is_public, :owner]
  table.hashes.each do |f|
    owner = User.friendly.find(f[:owner])
    group = UserGroup.where(name: f[:for_group]).first
    rt = RegularTraining.new({name: f[:name], description: f[:description], public: f[:is_public]})
    rt.user = owner
    rt.user_group = group
    rt.save!
  end
end

When(/^I fill all required fields for regular training$/) do |table|
  # table is a table.hashes.keys # => [:name, :description, :public, :for_group]
  f = table.hashes.first
  fill_in 'Name', with: f[:name]
  fill_in 'Description', with: f[:description]
  if f[:public] == "true"
    check 'Public'
  end
  find(:xpath, "//select/option[contains(text(), '#{f[:for_group]}')]").select_option
end

And(/^I click New training in action box$/) do
  within find('#action-box') do
    click_link_or_button 'New training'
  end
end

And(/^Following training obligations exist$/) do |table|
  # table is a table.hashes.keys # => [:user, :hourly_wage_wt, :vat, :currency, :role, :regular_training]
  table.hashes.each do |o|
    regular_training = RegularTraining.friendly.find(o[:regular_training])
    currency = Currency.friendly.find(o[:currency])
    vat = Vat.friendly.find(o[:vat])

    CoachObligation.create(user: @user[1], regular_training: regular_training, currency: currency, vat: vat,
                           role: o[:role], hourly_wage_without_vat: o[:hourly_wage_wt], coach_email: @user[1].email)
  end
end