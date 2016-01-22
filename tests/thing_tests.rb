require '../table'

class Thing < Table
  attr_accessor :id, :name, :size

  def initialize(id: nil, name: nil, size: nil)
    @id = id
    @name = name
    @size = size
  end
end

class ThingTest
  def test_self_table_name
    Thing.table_name == 'things'
  end

  def test_self_table_directory
    Thing.table_directory == "./tables/"
  end

  def test_self_table_path
    Thing.table_path == "./tables/things.csv"
  end

  def test_self_find
    thing = Thing.find(1)
    thing.is_a?(Thing) &&
    thing.attributes == { id: 1, name: 'thing_one', size: 999 } &&
    thing.id == 1 &&
    thing.name == 'thing_one' &&
    thing.size == 999
  end

  def test_self_find_by
    thing = Thing.find_by(name: 'thing_two')
    thing.is_a?(Thing) &&
    thing.attributes == { id: 2, name: 'thing_two', size: 998 } &&
    thing.id == 2 &&
    thing.name == 'thing_two' &&
    thing.size == 998
  end

  def test_self_new
    thing = Thing.new(id: 3, name: 'thing_save', size: 997)
    thing.is_a?(Thing) &&
    thing.attributes == { id: 3, name: 'thing_save', size: 997 } &&
    thing.id == 3 &&
    thing.name == 'thing_save' &&
    thing.size == 997
  end

  def test_self_create
    thing = Thing.create(id: 4, name: 'thing_create', size: 997)
    thing.is_a?(Thing) &&
    thing.attributes == { id: 4, name: 'thing_create', size: 997 } &&
    thing.id == 4 &&
    thing.name == 'thing_create' &&
    thing.size == 997
  end

  def test_save
    thing = Thing.new(id: 5, name: 'thing_save', size: 996).save
    thing.is_a?(Thing) &&
    thing.attributes == { id: 5, name: 'thing_save', size: 996 } &&
    thing.id == 5 &&
    thing.name == 'thing_save' &&
    thing.size == 996
  end

  def test_update
    thing = Thing.find_by(name: 'thing_save').update(name: 'thing_update')
    thing.is_a?(Thing) &&
    thing.attributes == { id: 5, name: 'thing_update', size: 996 } &&
    thing.id == 5 &&
    thing.name == 'thing_update' &&
    thing.size == 996
  end

  def test_destroy
    thing = Thing.find_by(name: 'thing_update').destroy
    thing.is_a?(Thing) &&
    thing.attributes == { id: 5, name: 'thing_update', size: 996 } &&
    thing.id == 5 &&
    thing.name == 'thing_update' &&
    thing.size == 996
  end

  def test_attributes
    Thing.find_by(name: 'thing_one').attributes == { id: 1, name: 'thing_one', size: 999 }
  end

end

output = ''
output << (ThingTest.new.test_self_table_name ? '.' : 'F')
output << (ThingTest.new.test_self_table_directory ? '.' : 'F')
output << (ThingTest.new.test_self_table_path ? '.' : 'F')
output << (ThingTest.new.test_self_find ? '.' : 'F')
output << (ThingTest.new.test_self_find_by ? '.' : 'F')
output << (ThingTest.new.test_self_new ? '.' : 'F')
output << (ThingTest.new.test_self_create ? '.' : 'F')
output << (ThingTest.new.test_save ? '.' : 'F')
output << (ThingTest.new.test_update ? '.' : 'F')
output << (ThingTest.new.test_destroy ? '.' : 'F')
output << (ThingTest.new.test_attributes ? '.' : 'F')
puts output


