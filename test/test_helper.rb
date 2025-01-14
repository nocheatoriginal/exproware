require 'simplecov'
SimpleCov.start 'rails'

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    #parallelize(workers: :number_of_processors)
    # Fix problem with parallelize
    max_parallel_tests = 100
    number_of_tests = Dir.glob('test/**/*_test.rb').size
    max_workers = [Integer(number_of_tests / (max_parallel_tests / 5.0)), 1].max
    parallelize(workers: max_workers)


    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
