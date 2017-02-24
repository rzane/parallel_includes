require 'active_record'
require 'parallel_includes/version'

module ParallelIncludes
  class Batch < Array
    def flat_map
      threads = map do |item|
        Thread.new do
          ActiveRecord::Base.connection_pool.with_connection do
            yield item
          end
        end
      end

      threads.flat_map(&:value)
    end
  end

  class Preloader < ActiveRecord::Associations::Preloader
    def preload(records, associations, preload_scope = nil)
      super(records, Batch.new(associations), preload_scope)
    end
  end

  module Relation
    def parallel
      clone.parallel!
    end

    def parallel!
      @parallel_preloader = Preloader.new
      self
    end

    private

    def build_preloader
      @parallel_preloader || super
    end
  end
end

ActiveRecord::Relation.prepend ParallelIncludes::Relation
