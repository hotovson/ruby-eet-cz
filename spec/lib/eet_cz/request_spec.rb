# frozen_string_literal: true
require 'spec_helper'

describe EET_CZ::Request do
  let(:receipt) do
    EET_CZ::Receipt.new(
      dat_trzby:  Time.parse('2016-08-05T00:30:12+02:00'),
      id_pokl:    '/5546/RO24',
      porad_cis:  '0/6460/ZQ42',
      celk_trzba: 34_113.00,
      uuid_zpravy: 'ad88adc8-56b6-4403-9cf5-ef05108b86f0',
      dat_odesl: Time.parse('2017-02-10T11:53:07+01:00')
    )
  end

  let(:request) { EET_CZ::Request.new(receipt) }

  it 'generates proper header' do
    expect(request.header).to eq test_header
  end

  it 'generates proper data' do
    expect(request.data).to eq test_data
  end

  it 'generates proper footer' do
    expect(request.footer).to eq test_footer
  end

  private

  def test_header
    {
      'eet:Hlavicka' => {
        '@uuid_zpravy' => 'ad88adc8-56b6-4403-9cf5-ef05108b86f0',
        '@dat_odesl' => '2017-02-10T11:53:07+01:00',
        '@prvni_zaslani' => 'true',
        '@overeni' => 'true'
      }
    }
  end

  def test_data
    {
      'eet:Data' => {
        '@dic_popl' => 'CZ00000019',
        '@id_provoz' => '273',
        '@id_pokl' => '/5546/RO24',
        '@porad_cis' => '0/6460/ZQ42',
        '@dat_trzby' => '2016-08-05T00:30:12+02:00',
        '@celk_trzba' => '34113.00',
        '@rezim' => '0'
      }
    }
  end

  def test_footer
    {
      'eet:KontrolniKody' => {
        'eet:pkp' => {
          '@digest' => 'SHA256',
          '@cipher' => 'RSA2048',
          '@encoding' => 'base64',
          :content! => 'a0asEiJhFCBlVtptSspKvEZhcrvnzF7SQ55C4DhnStnSu1b37GUI2+Dlme9P94UCPZ1oCUPJdsYOBZ3IX6aEgEe0FJKXYX0kXraYCJKIo3g64wRchE7iblIOBCK1uHh8qqHA66Isnhb6hqBOOdlt2aWO/0jCzlfeQr0axpPF1mohMnP3h3ICaxZh0dnMdju5OmMrq+91PL5T9KkR7bfGHqAoWJ0kmxY/mZumtRfGil2/xf7I5pdVeYXPgDO/Tojzm6J95n68fPDOXTDrTzKYmqDjpg3kmWepLNQKFXRmkQrkBLToJWG1LDUDm3UTTmPWzq4c0XnGcXJDZglxfolGpA=='
        },
        'eet:bkp' => {
          '@digest' => 'SHA1',
          '@encoding' => 'base16',
          :content! => '9356D566-A3E48838-FB403790-D201244E-95DCBD92'
        }
      }
    }
  end
end
