require 'active_record'
require 'parallel_includes/version'

module ParallelIncludes
  class Preloader < ActiveRecord::Associations::Preloader
    attr_reader :preload_threads

    def initialize
      @preload_threads = []
    end

    def preload(_, associations, *)
      self.preload_threads << Thread.new do
        ActiveRecord::Base.connection_pool.with_connection do
          super
        end
      end
    end

    def join
      preload_threads.each(&:join)
    end
  end

  module Relation
    def parallel
      clone.parallel!
    end

    def parallel!
      self.parallel_preload = true
      self
    end

    private

    # @override
    def exec_queries(&block)
      if parallel_preload?
        with_parallel_preloading { super }
      else
        super
      end
    end

    # @override
    def build_preloader
      parallel_preloader || super
    end

    attr_writer   :parallel_preload
    attr_accessor :parallel_preloader

    def parallel_preload?
      @parallel_preload || false
    end

    def with_parallel_preloading
      self.parallel_preloader = Preloader.new
      yield.tap { parallel_preloader.join }
    ensure
      self.parallel_preloader = nil
    end
  end
end

ActiveRecord::Relation.prepend ParallelIncludes::Relation
