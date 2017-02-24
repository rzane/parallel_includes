require 'test_helper'
ActiveRecord::Base.logger = Logger.new(STDOUT)

class ParallelIncludesTest < Minitest::Test
  def test_it_does_something_useful
    reflections = Thing.reflections
    associated = reflections.map { |name, refl|
      [name.to_sym, refl.klass.create!]
    }.to_h

    thing = Thing.create! associated
    found = Thing.includes(associated.keys).first

    associated.each do |key, value|
      assert found.send(key).id == value.id
    end
  end
end
