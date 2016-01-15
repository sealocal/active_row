require './table'

class Tweet < Table
  # These attributes must mach the CSV schema.
  attr_accessor :id, :text, :username

  # #new(text: 'hello world!')
  def initialize(id: nil, text: nil, username: nil)
    @id = id
    @text = text
    @username = username
  end
end

puts Table.table_name
puts Table.new.table_name
puts Table.table_path
puts Table.new.table_path
puts Table.table_directory
puts Table.new.table_directory

puts Tweet.table_name
puts Tweet.new.table_name
puts Tweet.table_path
puts Tweet.new.table_path
puts Tweet.table_directory
puts Tweet.new.table_directory
puts Tweet.new.attributes


# Build a new tweet and save it
exit unless Tweet.new(id: 2, text: 'save a tweet!', username: 'sea_local').save

# Build a new tweet
t = Tweet.new(id: 1, text: 'save another tweet!', username: 'sea_local')
# Save it
t.save
p t

# Create a tweet
t = Tweet.create(id: 3, text: 'create a tweet!', username: 'sea_local')
p t

# Find a tweet
t = Tweet.find_by(text: 'save another tweet!', username: 'sea_local')
# View the attributes
p t.attributes
# Update the tweet
p t.update(text: 'update a tweet!', username: 'updater') # => true
p t.attributes

# Find a tweet and delete it
params = { text: 'delete me!', username: 'sea_local' }
Tweet.create({ id: 4 }.merge(params))
t = Tweet.find_by(params)
p t.destroy

