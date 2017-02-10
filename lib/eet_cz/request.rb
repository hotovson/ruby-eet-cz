# frozen_string_literal: true

module EET_CZ
  class Error < StandardError; end
  class HTTPError < Error; end
  class SOAPError < Error; end

  class Request
    include Constants

    attr_reader :receipt, :soap_client, :options

    # options:
    # @prvni_zaslani: true=first try; false=retry
    def initialize(receipt, options = {}, soap_client = SOAPClient.client)
      raise('certificate not found') if EET_CZ.config.ssl_cert_file.blank?
      @receipt = receipt
      @options = options
      @soap_client = soap_client
    end

    def run
      response = soap_client.call('Trzba', soap_action: 'http://fs.mfcr.cz/eet/OdeslaniTrzby', message: message)
      EET_CZ::Response.parse(response.doc)
    rescue Savon::HTTPError => e
      raise HTTPError, e.to_s
    rescue Savon::SOAPFault => e
      raise SOAPError, e.to_s
    end

    def message
      [header, data, footer].reduce({}, :merge)
    end

    def header
      { 'eet:Hlavicka' => format_attributes(HEADER_ATTRIBUTES) }
    end

    def data
      { 'eet:Data' => compacted(format_attributes(DATA_ATTRIBUTES)) }
    end

    def footer
      {
        'eet:KontrolniKody' => {
          'eet:pkp' => {
            '@digest' => 'SHA256',
            '@cipher'   => 'RSA2048',
            '@encoding' => 'base64',
            :content!   => receipt.pkp
          },
          'eet:bkp' => {
            '@digest'   => 'SHA1',
            '@encoding' => 'base16',
            :content!   => receipt.bkp
          }
        }
      }
    end

    private

    def format_attributes(attributes)
      attrs = attributes.map { |atr| ["@#{atr}", receipt.send(atr)] }.flatten
      Hash[*attrs]
    end

    def compacted(attributes)
      attributes.reject { |_, v| v.blank? || v == '0.00' }
    end
  end
end
