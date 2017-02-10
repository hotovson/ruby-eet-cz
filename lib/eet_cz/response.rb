# frozen_string_literal: true

module EET_CZ
  class Response
    attr_reader :attributes, :doc

    def self.parse(xml_response)
      xml_response.remove_namespaces!
      doc = xml_response.at('Odpoved')
      new(doc).send :parse
    end

    private

    def initialize(doc)
      @doc = doc
      @attributes = OpenStruct.new
    end

    def parse
      parse_warnings
      parse_header
      parse_data
      self
    end

    def parse_warnings
      attributes.warnings = []
      doc.search('Varovani').each do |warning|
        attributes.warnings << parse_warning(warning)
      end
    end

    def parse_warning(warning)
      OpenStruct.new(
        kod: warning.attributes['kod_varov'].try(:value).try(:to_i),
        text: warning.text.squish
      )
    end

    def parse_header
      attributes.uuid_zpravy = header_attribute('uuid_zpravy')
      attributes.bkp         = header_attribute('bkp')
    end

    def header_attribute(attr)
      doc.at('Hlavicka').attributes[attr].try(:value)
    end

    def parse_data
      attributes.dat_prij   = header_attribute('dat_prij')
      attributes.dat_odmit  = header_attribute('dat_odmit')
      attributes.fik        = inner_doc.attributes['fik'].try(:value)
      attributes.kod        = inner_doc.attributes['kod'].try(:value).try(:to_i)
      attributes.error      = inner_doc.text
      attributes[:test?]    = inner_doc.attributes['test'].try(:value) == 'true'
      attributes[:success?] = with_success? || (with_error? && attributes.kod.zero? && attributes.test?)
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
  end
end
