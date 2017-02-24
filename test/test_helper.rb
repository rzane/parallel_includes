$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'parallel_includes'
require 'pry'
require 'minitest/autorun'
require_relative './models'

ActiveRecord::Base.logger = Logger.new(STDOUT)
