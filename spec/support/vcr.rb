# frozen_string_literal: true

require 'webmock/rspec'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/support/cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
end
