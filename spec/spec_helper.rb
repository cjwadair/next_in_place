require 'simplecov'
SimpleCov.start

require 'bundler/setup'
require 'next_in_place'
require 'rails'
require 'active_record'
require 'with_model'

RSpec.configure do |config|
  config.extend WithModel
  ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Rails.application.initialize
end
