# frozen_string_literal: true

require 'eet_cz'

module CertFixturePath
  def cert_fixture_path(cert)
    "./spec/support/fixtures/cert/#{cert}"
  end
end

RSpec.configure do |config|
  config.include CertFixturePath

  config.before(:each) do
    EET_CZ.configure do |c|
      c.endpoint              = EET_CZ::PG_EET_URL
      c.ssl_cert_file         = cert_fixture_path('EET_CA1_Playground-CZ00000019.p12')
      c.ssl_cert_key_file     = cert_fixture_path('EET_CA1_Playground-CZ00000019.p12')
      c.ssl_cert_key_password = 'eet'
      c.overeni               = 'true' # Use only test mode! It sends overeni='true'
      c.debug_logger          = false
      c.dic_popl              = 'CZ00000019'
      c.id_provoz             = '273'
      c.rezim                 = '0' # 0 - bezny rezim, 1 - zjednoduseny rezim
    end
  end
end
