$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'parallel_includes'
require 'benchmark/ips'
require_relative '../test/models'

def prepare
  puts 'Deleting all records...'
  ActiveRecord::Base.descendants.each do |model|
    model.delete_all
  end

  puts 'Loading some data...'
  yield
  puts 'Starting the benchmark...'
end
