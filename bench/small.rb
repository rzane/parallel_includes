require_relative 'bench_helper'

prepare do
  10.times do
    Thing.create_with_associations!
  end
end

Benchmark.ips do |x|
  x.report 'non-parallel' do
    Thing.includes(Thing::ASSOCIATIONS).each { }
  end

  x.report 'parallel' do
    Thing.includes(Thing::ASSOCIATIONS).parallel.each { }
  end

  x.compare!
end
