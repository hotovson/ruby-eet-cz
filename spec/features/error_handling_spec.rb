# frozen_string_literal: true

require 'spec_helper'

describe 'error handling' do
  let(:receipt) do
    EET_CZ::Receipt.new(dat_trzby:  Time.parse('2016-08-05T00:30:12+02:00'),
                        id_pokl:    '/5546/RO24',
                        porad_cis:  '0/6460/ZQ42',
                        celk_trzba: 34_113.00)
  end
  let(:nori) { Nori.new(strip_namespaces: true, convert_tags_to: ->(tag) { tag.snakecase.to_sym }) }
  let(:http_error) { Savon::HTTPError.new(HTTPI::Response.new(404, {}, 'Not Found')) }
  let(:soap_fault) { Savon::SOAPFault.new HTTPI::Response.new(500, {}, soap_fault_xml), nori }

  it 'raises EET_CZ::HTTPError' do
    client = double
    allow(client).to receive(:call).and_raise(http_error)
    request = EET_CZ::Request.new(receipt, {}, client)
    expect { request.run }.to raise_error(EET_CZ::HTTPError)
  end

  it 'raises EET_CZ::SOAPError' do
    client = double
    allow(client).to receive(:call).and_raise(soap_fault)
    request = EET_CZ::Request.new(receipt, {}, client)
    expect { request.run }.to raise_error(EET_CZ::SOAPError)
  end

  it 'raises '

  private

  def soap_fault_xml
    <<~HEREDOC
      <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
        <soap:Body>
          <soap:Fault>
             <faultcode>soap:Server</faultcode>
             <faultstring>Fault occurred while processing.</faultstring>
          </soap:Fault>
        </soap:Body>
      </soap:Envelope>
    HEREDOC
  end
end
