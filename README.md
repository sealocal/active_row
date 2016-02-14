# active_row

A Ruby class with methods that will perform CRUD operations on a specified CSV file. The methods provided are intended to follow the Active Record pattern.

# Example Setup

1. Create a file similar to the examples below.
2. From the same directory, create a CSV like `./tables/tweets.csv`.
2. Replace `Tweet` with `YourClassName`.

## tweet.rb

```ruby
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
```
