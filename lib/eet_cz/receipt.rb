# frozen_string_literal: true
module EET_CZ
  class Receipt
    include ActiveModel::Validations

    VALID_FORMAT = %r(\A[0-9a-zA-Z\.,:;\/#\-_]{1,20}\z)
    NUMERIC_ATTRIBUTES = [
      :celk_trzba,
      :zakl_nepodl_dph,
      :zakl_dan1, :dan1,
      :zakl_dan2, :dan2,
      :zakl_dan3, :dan3
    ].freeze

    attr_reader :id_pokl, :porad_cis

    validates :id_pokl, presence: true, format: VALID_FORMAT
    validates :porad_cis, presence: true, format: VALID_FORMAT
    validates :dat_trzby, presence: true
    validates :celk_trzba, presence: true

    def initialize(attributes = {})
      attributes.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def uuid_zpravy
      @uuid_zpravy ||= SecureRandom.uuid
    end

    def dat_trzby
      (@dat_trzby || Time.current).iso8601
    end

    def method_missing(name, *args, &block)
      return formated_numeric(name) if NUMERIC_ATTRIBUTES.include?(name)
      super
    end

    def respond_to_missing?
      true
    end

    private

    def formated_numeric(attribute)
      format('%.2f', instance_variable_get("@#{attribute}").to_f)
    end
  end
end
