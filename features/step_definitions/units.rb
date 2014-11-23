And(/^Following unit types exist in the system$/) do |table|
  # table is a table.hashes.keys # => [:name]
  # Unit types are hardcode-stored as an array inside Unit
end

And(/^Following units exist in the system$/) do |table|
  # table is a table.hashes.keys # => [:name, :unit_type, :description, :abbreviation]
  table.hashes.each do |t|
    Unit.create(name: t[:name], unit_type: t[:unit_type], description: t[:description], abbreviation: t[:abbreviation])
  end
end