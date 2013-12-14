require 'spec_helper'

describe Clamd::Client do
  let(:client) {described_class.new}
  let(:file_path) {File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'clamdoc.pdf'))}
  let(:directory_path) {File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'documents'))}
  let(:file_with_virus_path) {File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'virus'))}

  describe '#ping' do
    it 'gets PONG if ClamAV daemon alive' do
      expect(client.ping).to eq('PONG')
    end
  end

  describe '#version' do
    it 'gets version of the ClamAV' do
      expect(client.version).to match(/^ClamAV \d+.\d+.\d+/)
    end
  end

  describe '#reload' do
    it 'reloads ClamAV virus signature database' do
      expect(client.reload).to eq('RELOADING')
    end
  end

  describe '#scan' do
    it 'scans the given file' do
      expect(client.scan file_path).to match(/^.*: OK$/)
    end

    it 'scans the given directory' do
      expect(client.scan directory_path).to match(/^.*: OK$/)
    end

    it "reports thread if virus found" do
      expect(client.scan file_with_virus_path).to match(/^.*: (.+?) FOUND$/)
    end
  end

  describe '#multiscan' do
    it 'scans the given file using multiscan feature' do
      expect(client.multiscan file_path).to match(/^.*: OK$/)
    end

    it 'scans the given directory using multiscan feature' do
      expect(client.multiscan directory_path).to match(/^.*: OK$/)
    end
  end
  
  describe '#contscan' do
    it 'scans the given file using contscan feature' do
      expect(client.contscan file_path).to match(/^.*: OK$/)
    end

    it 'scans the given directory using contscan feature' do
      expect(client.contscan directory_path).to match(/^.*: OK$/)
    end
  end
end
