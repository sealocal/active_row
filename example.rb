require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'active_row', '0.0.1'
end

class Tweet < ActiveRow
  # These attributes must mach the CSV schema.
  attr_accessor :id, :text, :username

  # #new(text: 'hello world!')
  def initialize(id: nil, text: nil, username: nil)
    @id = id
    @text = text
    @username = username
  end
end

puts ActiveRow.table_name
puts ActiveRow.new.table_name
puts ActiveRow.table_path
puts ActiveRow.new.table_path
puts ActiveRow.table_directory
puts ActiveRow.new.table_directory

puts Tweet.table_name
puts Tweet.new.table_name
puts Tweet.table_path
puts Tweet.new.table_path
puts Tweet.table_directory
puts Tweet.new.table_directory
puts Tweet.new.attributes


# Build a new tweet and save it
exit unless Tweet.new(id: 1, text: 'save a tweet!', username: 'sea_local').save

# Build a new tweet
t = Tweet.new(id: 2, text: 'save another tweet!', username: 'sea_local')
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

