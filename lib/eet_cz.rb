# frozen_string_literal: true

require 'active_support/configurable'
require 'active_model'
require 'savon'

require 'eet_cz/version'
require 'eet_cz/constants'
require 'eet_cz/receipt'
require 'eet_cz/request'
require 'eet_cz/response'
require 'eet_cz/soap_client'
require 'eet_cz/akami_patch'

module EET_CZ
  include ActiveSupport::Configurable
  # TODO: validation for config values?

  PG_EET_URL   = 'https://pg.eet.cz:443/eet/services/EETServiceSOAP/v3/'
  PROD_EET_URL = 'https://prod.eet.cz:443/eet/services/EETServiceSOAP/v3/'

  def self.working_dir
    Dir.pwd
  end
end
