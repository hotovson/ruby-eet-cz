# frozen_string_literal: true
require 'spec_helper'

describe EET_CZ::Receipt do
  let(:receipt) { EET_CZ::Receipt.new }

  it 'returns instance' do
    expect(receipt).to be_an_instance_of(EET_CZ::Receipt)
  end

  context 'default receipt' do
    it 'is invalid' do
      expect(receipt).not_to be_valid
    end

    it 'has missing attributes id_pokl, porad_cis' do
      receipt.valid?
      expect(receipt.errors.keys).to match %i(id_pokl porad_cis dat_trzby dat_odesl celk_trzba)
    end

    it 'has overeni = true as default' do
      expect(receipt.overeni).to eq 'true'
    end
  end

  context 'receipt with sufficient attributes' do
    let(:receipt) do
      EET_CZ::Receipt.new(
        dat_trzby: Time.parse('2016-08-05T00:30:12+02:00'),
        dat_odesl: Time.parse('2016-08-05T00:30:12+02:00'),
        dic_popl: 'CZ1212121218',
        id_pokl: '/5546/RO24',
        porad_cis: '0/6460/ZQ42',
        celk_trzba: 34_113.00
      )
    end

    it 'is valid' do
      expect(receipt).to be_valid
    end

    it 'has valid plain_text' do
      expect(receipt.plain_text).to eq test_plain_text
    end

    it 'has valid pkp' do
      expect(receipt.pkp).to eq(test_p12_pkp)
    end

    it 'has valid bkp' do
      expect(receipt.bkp).to eq('218F8FAF-00C882D1-612CCA1A-5753647E-01D129DA')
    end

    private

    def test_p12_pkp
      %(hlDZ+XY0Mct2BibywpfoRw+RQZwmgl/SpQhmBBbKEYYZko6B71XiPevvKFNZuqkQb3kwvn3QSqKGe2mxm6Q0PtexfOWu
      NRoThH/PVI8SyVqRg4EcHi37/2VQxF/QJG+JH/BFHdSxE2ROSvG/GEHDIpmHhBRkCoY+9723UTjyx0vXr4FhNODbPWrhje
      M/sCoLEi5HT2dAsI2wIg4QE9K1o+szSOdqlAdkey7M6m12AQW0LkBSPqPUi3NWa+Flo9xAPRyEKA49EQpndngu+kgPncEl
      IfczSyhWOdQVq3D9FSwRD1ZXaY7tvyYgWLmNNF3xNn3ahCN0Hu41+wMPsqLGQw==).gsub(/\s/, '').strip
    end

    def test_plain_text
      'CZ1212121218|273|/5546/RO24|0/6460/ZQ42|2016-08-05T00:30:12+02:00|34113.00'
    end
  end
end
