And(/^Following exercises exist in the system$/) do |table|
  # table is a table.hashes.keys # => [:code, :name, :description, :accessibility, :owner]
  table.hashes.each do |r|
    user = User.friendly.find(r[:owner])
    Exercise.create({name: r[:name], description: r[:description], accessibility: r[:accessibility], user: user})
  end
end