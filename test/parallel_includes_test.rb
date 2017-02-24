require_relative 'test_helper'

class ParallelIncludesTest < Minitest::Test
  def setup
    Thing.create! associated
  end

  def test_it_does_something_useful
    Thing.includes(associated.keys).parallel.first
  end

  private

  def associated
    @associated ||= Thing.reflections.map do |name, refl|
      [name.to_sym, refl.klass.create!]
    end.to_h
  end
end
