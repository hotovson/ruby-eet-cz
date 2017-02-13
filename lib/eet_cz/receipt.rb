# frozen_string_literal: true
module EET_CZ
  class Receipt
    include ActiveModel::Validations
    include Constants

    attr_reader :attributes

    validates :id_provoz, presence: true, format: ID_PROVOZ_FORMAT
    validates :id_pokl, presence: true, format: ID_POKL_FORMAT
    validates :porad_cis, presence: true, format: PORAD_CISL_FORMAT
    validates :dat_trzby, presence: true, format: ISO8601_FORMAT
    validates :dat_odesl, presence: true, format: ISO8601_FORMAT
    validates :celk_trzba, presence: true
    validates :uuid_zpravy, presence: true, format: UUID_ZPRAVY_FORMAT
    validates :prvni_zaslani, presence: true
    validates :dic_popl, presence: true, format: DIC_POPL_FORMAT
    validates :rezim, presence: true, format: REZIM_FORMAT
    validates :bkp, presence: true, format: BKP_FORMAT
    validates :pkp, presence: true, format: PKP_FORMAT

    RECEIPT_ATTRIBUTES.each do |attribute|
      define_method(attribute) { @attributes[attribute] }
    end
    NUMERIC_ATTRIBUTES.each do |attribute|
      define_method("#{attribute}=") { |value| @attributes[attribute] = formated_numeric(value) }
    end
    DATETIME_ATTRIBUTES.each do |attribute|
      define_method("#{attribute}=") { |value| @attributes[attribute] = formated_datetime(value) }
    end
    OTHER_ATTRIBUTES.each do |attribute|
      define_method("#{attribute}=") { |value| @attributes[attribute] = value.to_s }
    end

    def initialize(attrs = {})
      @attributes = OpenStruct.new(defaults)
      attrs.to_h.each do |key, value|
        send("#{key}=", value)
      end
    end

    # Digest from pkp, i.e: '03ec1d0e-6d9f77fb-1d798ccb-f4739666-a4069bc3'
    def bkp
      Digest::SHA1.hexdigest(Base64.strict_decode64(pkp)).upcase.scan(/.{8}/).join('-')
    end

    # @return base64 signed text from plain_text.
    # plain_text consists of:
    # DIC_POPL|ID_PROVOZ|ID_POKL|PORAD_CIS|DAT_TRZBY|CELK_TRZBA
    # i.e: "CZ72080043|181|00/2535/CN58|0/2482/IE25|2016-12-07T22:01:00+01:00|87988.00"
    def pkp
      Base64.strict_encode64(private_key.sign(OpenSSL::Digest::SHA256.new, plain_text))
    end

    def plain_text
      [dic_popl, id_provoz, id_pokl, porad_cis, dat_trzby, celk_trzba].join('|')
    end

    private

    def private_key
      case cert_key_type
      when 'p12'
        OpenSSL::PKCS12.new(File.read(EET_CZ.config.ssl_cert_key_file), EET_CZ.config.ssl_cert_key_password).key
      when 'pem'
        OpenSSL::PKey::RSA.new(File.read(EET_CZ.config.ssl_cert_key_file), EET_CZ.config.ssl_cert_key_password)
      end
    end

    def cert_key_type
      EET_CZ.config.ssl_cert_key_file.split('.').last || 'p12'
    end

    def formated_numeric(value)
      format('%.2f', value.to_f)
    end

    def formated_datetime(value)
      (value.respond_to?(:iso8601) ? value.iso8601 : Time.parse(value).iso8601).to_s
    end

    def set_defaults
      defaults.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def defaults
      {
        id_provoz: EET_CZ.config[:id_provoz],
        id_pokl: EET_CZ.config[:id_pokl],
        overeni: EET_CZ.config[:overeni] == 'false' ? 'false' : 'true',
        prvni_zaslani: 'true',
        uuid_zpravy: SecureRandom.uuid,
        dat_trzby: formated_datetime(Time.now),
        dat_odesl: formated_datetime(Time.now),
        dic_popl: EET_CZ.config[:dic_popl],
        rezim: EET_CZ.config[:rezim] == '1' ? '1' : '0'
      }
    end
  end
end

#   * uuid_zpravy
#   * dat_odesl
#   * prvni_zaslani
#   * dic_popl
#   * rezim
#   * pkp
#   * bkp
#     overeni
#   * id_provoz
#   * id_pokl
#   * porad_cis
#   * dat_trzby
#   * celk_trzba
#     zakl_nepodl_dph     #  0 % DPH
#     zakl_dan1           # 21 % DPH
#     dan1
#     zakl_dan2           # 15 % DPH (prvni snizena)
#     dan2
#     zakl_dan3           #  5 % DPH (druha snizena)
#     dan3
#        dic_poverujiciho
#        cest_sluz
#        pouzit_zboz1
#        pouzit_zboz2
#        pouzit_zboz3
#        urceno_cerp_zuct
#        cerp_zuct
