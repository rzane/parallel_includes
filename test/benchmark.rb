$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'parallel_includes'
require 'benchmark/ips'
require_relative './models'

ASSOCIATIONS = %i(one two three four five six)

associated = Thing.reflections.map do |name, refl|
  [name.to_sym, refl.klass.create!]
end

Thing.create! Hash[associated]

Benchmark.ips do |x|
  x.report 'non-parallel' do
    Thing.includes(ASSOCIATIONS).each { }
  end

  x.report 'parallel' do
    Thing.includes(ASSOCIATIONS).parallel.each { }
  end
end
