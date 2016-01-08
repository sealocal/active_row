require 'csv'
require './class_attribute'

class Table

  CONVERTERS = :all

  class_attribute :table_name, :table_directory

  def self.table_name
    "#{self.name.downcase}s"
  end

  def self.table_directory
    "./tables/"
  end

  def self.table_path
    "#{self.table_directory}#{self.table_name}"
  end

  # Returns self if a row is found and returns nil if no row is found
  def self.find(id = nil)
    csv_table = CSV.table(table_path, converters: CONVERTERS)
    csv_row = csv_table.find { |row| row.field(:id) == id }
    csv_row ? self.new(csv_row.to_hash) : nil
  end

  # Returns self if a row is found and returns nil if no row is found
  def self.find_by(id: nil, text: nil, username: nil)
    parameters, args = [], {}
    # Copy the provided parameters from local_variables to parameters,
    # explicitly excluding :parameters and :args from the parameters hash
    local_variables.each { |local| parameters << local unless [:parameters, :args].include? local }
    parameters.each { |param| args[param] = binding.local_variable_get(param) }
    args.reject! { |k, v| v == nil }
    csv_table = CSV.table(table_path, converters: CONVERTERS)
    # Find the row where values in the CSV::Row are
    # equal to the values of the attributes that were provided
    csv_row = csv_table.find { |row| row.values_at(*args.keys) == args.values}
    csv_row ? self.new(csv_row.to_hash) : nil
  end

  # These attributes must mach the CSV schema.
  attr_accessor :id, :text, :username

  # #new(text: 'hello world!')
  def initialize(id: nil, text: nil, username: nil)
    @id = id
    @text = text
    @username = username
  end

  def save
    CSV.open(table_path, 'a+') do |csv| # a+ => append to document
      # concatenate an array of values [1, 'text', 'username']
      csv << CSV::Row.new(attributes.keys, attributes.values).fields
    end
    true
  end

  def self.create(id: nil, text: nil, username: nil)
    parameters, args = [], {}
    # Copy the provided parameters from local_variables to parameters,
    # explicitly excluding :parameters and :args from the parameters hash
    local_variables.each { |local| parameters << local unless [:parameters, :args].include? local }
    parameters.each { |param| args[param] = binding.local_variable_get(param) }
    args.reject! { |k, v| v == nil }
    CSV.open(table_path, 'a+') do |csv| # a+ => append to document
      # concatenate an array of values [1, 'text', 'username']
      csv << CSV::Row.new(args.keys, args.values).fields
    end
    self.new(id: id, text: text, username: username)
  end

  def update(text: nil, username: nil)
    parameters, args = [], {}
    # Copy the provided parameters from local_variables to parameters,
    # explicitly excluding :parameters and :args from the parameters hash
    local_variables.each { |local| parameters << local unless [:parameters, :args].include? local }
    parameters.each { |param| args[param] = binding.local_variable_get(param) }
    args.reject! { |k, v| v == nil }
    csv_table = CSV.table(table_path, converters: CONVERTERS)
    old_row = csv_table.find { |row| row.field(:id) == id }
    new_row = CSV::Row.new(old_row.headers, old_row.fields)

    # Assign new values to the row by param name (which should be a field name)
    args.each { |k, v| new_row[k] = v }
    # Delete the old_row
    csv_table = CSV.table(table_path, converters: CONVERTERS)
    csv_table.delete_if do |row|
      row == old_row
    end
    csv_table << new_row
    # Write the csv_table to a file, replacing the original
    File.open(table_path, 'w') do |f| # w => write-only
      f.write(csv_table.to_csv)
    end
    # Note: AR returns true if successful, false if not.
    # If AR is successful, it updates the receiving instance's attributes.
    # This returns a new instance with the variables on success.
    new_row ? self.class.new(new_row.to_hash) : false
  end

  def destroy
    csv_table = CSV.table(table_path, converters: CONVERTERS)
    # Delete the row from the table if it is equivalent to the receiving instance.
    csv_table.delete_if do |row|
      row == CSV::Row.new(attributes.keys, attributes.values)
    end

    # Write the csv_table to a file, replacing the original
    File.open(table_path, 'w') do |f| # w => write-only
      f.write(csv_table.to_csv)
    end

    # Get the file's contents and close it
    file = File.open(table_path, 'rb')
    contents = file.read
    file.close

    # If all rows but the header have been deleted...
    if contents.lines.count < 2
       # then ensure the headers are still there.
       File.open(table_path, 'w') do |f| # w => write-only
        f.write(attributes.keys.map(&:to_s).join(','))
      end
    end
    self
  end

  # Returns a hash of the receiving's instance variables.
  def attributes
    attrs = {}
    instance_variables.each { |instance_variable|
      # Convert the instariable to a string, removing the @ (instance notation), and convert back to a symbol
      attrs[instance_variable.to_s[1..-1].to_sym] = instance_variable_get(instance_variable)
    }
    attrs
  end

  def attributes=(new_attributes)
    new_attributes.each { |key, value| instance_variable_set(key, value) }
    attributes
  end
end
