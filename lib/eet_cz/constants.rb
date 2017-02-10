# frozen_string_literal: true

module EET_CZ
  module Constants
    RECEIPT_ATTRIBUTES = [
      :uuid_zpravy,
      :dat_odesl,
      :prvni_zaslani,
      :dic_popl,
      :rezim,
      :pkp,
      :bkp,
      :overeni,
      :id_provoz,
      :id_pokl,
      :porad_cis,
      :dat_trzby,
      :celk_trzba,
      :zakl_nepodl_dph,
      :zakl_dan1,
      :dan1,
      :zakl_dan2,
      :dan2,
      :zakl_dan3,
      :dan3,
      :dic_poverujiciho,
      :cest_sluz,
      :pouzit_zboz1,
      :pouzit_zboz2,
      :pouzit_zboz3,
      :urceno_cerp_zuct,
      :cerp_zuct
    ].freeze
    NUMERIC_ATTRIBUTES = [
      :celk_trzba,
      :zakl_nepodl_dph,
      :zakl_dan1, :dan1,
      :zakl_dan2, :dan2,
      :zakl_dan3, :dan3,
      :cest_sluz,
      :pouzit_zboz1, :pouzit_zboz2, :pouzit_zboz3,
      :urceno_cerp_zuct, :cerp_zuct
    ].freeze
    DATETIME_ATTRIBUTES = [:dat_trzby, :dat_odesl].freeze
    OTHER_ATTRIBUTES = RECEIPT_ATTRIBUTES - NUMERIC_ATTRIBUTES - DATETIME_ATTRIBUTES

    HEADER_ATTRIBUTES = [:uuid_zpravy, :dat_odesl, :prvni_zaslani, :overeni].freeze
    DATA_ATTRIBUTES = [
      :dic_popl,
      :id_provoz,
      :id_pokl,
      :porad_cis,
      :dat_trzby,
      :celk_trzba,
      :zakl_nepodl_dph,
      :zakl_dan1,
      :dan1,
      :zakl_dan2,
      :dan2,
      :zakl_dan3,
      :dan3,
      :rezim
    ].freeze

    ISO8601_FORMAT = /(\d{4})-(\d{2})-(\d{2})T(\d{2})\:(\d{2})\:(\d{2})[+-](\d{2})\:(\d{2})/
    UUID_ZPRAVY_FORMAT = /\A[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}\z/x
    DIC_POPL_FORMAT = /\ACZ[0-9]{8,10}\z/
    ID_PROVOZ_FORMAT = /\A[1-9][0-9]{0,5}\z/
    ID_POKL_FORMAT = %r(\A[0-9a-zA-Z\.,:;/#\-_ ]{1,20}\z)
    PORAD_CISL_FORMAT = %r(\A[0-9a-zA-Z\.,:;/#\-_ ]{1,25}\z)
    REZIM_FORMAT = /\A[01]\z/
    BKP_FORMAT = /([0-9a-fA-F]{8}-){4}[0-9a-fA-F]{8}/
    PKP_FORMAT = %r(\A(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?\z)
  end
end
