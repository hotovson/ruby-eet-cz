# frozen_string_literal: true

module EET_CZ
  class Response
    attr_reader :doc, :uuid_zpravy, :bkp, :warnings,
                :fik, :dat_prij,
                :dat_odmit, :kod, :error

    def self.parse(xml_response)
      xml_response.remove_namespaces!
      doc = xml_response.at('Odpoved')
      new(doc).parse
    end

    def initialize(doc)
      @doc = doc
    end

    def parse
      parse_warnings
      parse_header
      parse_data
      self
    end

    def parse_warnings
      @warnings = []
      doc.search('Varovani').each do |warning|
        @warnings << parse_warning(warning)
      end
    end

    def parse_warning(warning)
      OpenStruct.new(
        kod: warning.attributes['kod_varov'].try(:value).try(:to_i),
        text: warning.text.squish
      )
    end

    def parse_header
      @uuid_zpravy = header_attribute('uuid_zpravy')
      @bkp         = header_attribute('bkp')
    end

    def header_attribute(attr)
      doc.at('Hlavicka').attributes[attr].try(:value)
    end

    def parse_data
      @test     = inner_doc.attributes['test'].try(:value)
      @fik      = inner_doc.attributes['fik'].try(:value)
      @kod       = inner_doc.attributes['kod'].try(:value).try(:to_i)
      @error     = inner_doc.text
      @dat_prij = header_attribute('dat_prij')
      @dat_odmit = header_attribute('dat_odmit')
    end

    def inner_doc
      @inner_doc ||= with_success? ? doc.at('Potvrzeni') : doc.at('Chyba')
    end

    def with_success?
      doc.at('Potvrzeni').present?
    end

    def with_error?
      doc.at('Chyba').present?
    end

    # If request was sent to Playground Endpoint
    def test?
      @test.present?
    end

    def success?
      with_success? || (with_error? && kod.zero? && test?)
    end
  end
end
