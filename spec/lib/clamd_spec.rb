require 'spec_helper'

describe Clamd do
  context "not configured" do
    it "should ask to configure ClamAV daemon details" do
      Clamd.ping.should == "ERROR: Please configure Clamd first"
    end
  end

  context "configured" do
    before do
      Clamd.configure do |config|
        config.host = ENV["host"]
        config.port = ENV["port"]
      end
    end

    it "should get PONG for the PING command" do
      Clamd.ping.should == "PONG"
    end

    it "should get ClamdAV version for VERSION command" do
      Clamd.version.should =~ /^ClamAV \d+.\d+.\d+/
    end

    it "should reload ClamAV virus signature database for RELOAD command" do
      Clamd.reload.should == "RELOADING"
    end 

    it "should scan the given file for SCAN command" do
      path = File.expand_path(File.join(File.dirname(__FILE__), "..", "fixtures", "clamdoc.pdf"))
      Clamd.scan(path).should =~ /^.*: OK$/
    end

    it "should scan the given directory for SCAN command" do
      path = File.expand_path(File.join(File.dirname(__FILE__), "..", "fixtures", "documents"))
      Clamd.scan(path).should =~ /^.*: OK$/
    end

    it "should multiscan the given file for MULTISCAN command" do
      path = File.expand_path(File.join(File.dirname(__FILE__), "..", "fixtures", "clamdoc.pdf"))
      Clamd.multiscan(path).should =~ /^.*: OK$/
    end

    it "should multiscan the given directory for MULTISCAN command" do
      path = File.expand_path(File.join(File.dirname(__FILE__), "..", "fixtures", "documents"))
      Clamd.multiscan(path).should =~ /^.*: OK$/
    end

    it "should contscan the given file for CONTSCAN command" do
      path = File.expand_path(File.join(File.dirname(__FILE__), "..", "fixtures", "clamdoc.pdf"))
      Clamd.contscan(path).should =~ /^.*: OK$/
    end

    it "should contscan the given directory for CONTSCAN command" do
      path = File.expand_path(File.join(File.dirname(__FILE__), "..", "fixtures", "documents"))
      Clamd.contscan(path).should =~ /^.*: OK$/
    end

    it "should report thread if virus found in the scan" do
      path = File.expand_path(File.join(File.dirname(__FILE__), "..", "fixtures", "virus"))
      Clamd.scan(path).should =~ /^.*: (.+?) FOUND$/
    end
  end
end
