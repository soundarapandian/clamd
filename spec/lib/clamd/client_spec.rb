require 'spec_helper'

describe Clamd::Client do
  let(:client) {described_class.new}
  let(:file_path) {File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'clamdoc.pdf'))}
  let(:directory_path) {File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'documents'))}
  let(:file_with_virus_path) {File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'virus'))}

  shared_examples 'virus scanner' do |mode|
    it 'scans the given file' do
      expect(client.send(mode, file_path)).to match(/^.*: OK$/)
    end

    it 'scans the given directory' do
      expect(client.send(mode, directory_path)).to match(/^.*: OK$/)
    end

    it "reports virus if found" do
      expect(client.send(mode, file_with_virus_path)).to match(/^.*: (.+?) FOUND$/)
    end
  end

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

  describe '#stats' do
    it 'displays ClamAV daemon scan queue status' do
      expect(client.stats).to match(/^POOLS:.*$/)
    end
  end

  describe '#scan' do
    include_examples 'virus scanner', 'scan'
  end

  describe '#multiscan' do
    include_examples 'virus scanner', 'multiscan'
  end

  describe '#contscan' do
    include_examples 'virus scanner', 'contscan'
  end

  describe '#instream' do
    it 'scans the given stream' do
      expect(client.instream file_path).to eq('stream: OK')
    end

    it "reports virus if found" do
      expect(client.instream file_with_virus_path).to match(/^.*: (.+?) FOUND$/)
    end
  end

  it 'supports to connect multiple ClamAV daemon with different configuration' do
    clamd1 = described_class.new(host: 'localhost')
    clamd2 = described_class.new(host: '127.0.0.1')

    expect(clamd1.ping).to eq('PONG')
    expect(clamd2.ping).to eq('PONG')
  end

  it 'reads global configuration if not specified for current client' do
    clamd = described_class.new

    expect(clamd.host).to eq('localhost')
    expect(clamd.port).to eq(9321)
  end
end
