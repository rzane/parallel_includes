require_relative 'bench_helper'

prepare do
  100.times do
    BigGuy.create_with_associations! num: 10
  end
end

Benchmark.ips do |x|
  x.report 'non-parallel' do
    Thing.includes(BigGuy::ASSOCIATIONS).each { }
  end

  x.report 'parallel' do
    Thing.includes(BigGuy::ASSOCIATIONS).parallel.each { }
  end

  x.compare!
end
