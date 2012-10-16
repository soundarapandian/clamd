# Clamd

Ruby gem to speak with Clamd daemon

NOTE: Still under development

## Installation

Add this line to your application's Gemfile:

    gem 'clamd'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install clamd

## Configuration

Refer the below code to configure the Clamd gem
    
    Clamd.configure do |config|
      config.host = "localhost" #mandatory
      config.port = 9321 #mandatory
      config.open_timeout = 5 #optional
      config.read_timeout = 20 #optional
      config.chunk_size = 10240 #optional
    end  

## Usage

To check ClamAV version

    Clamd.version

Response will be like below

    =>"ClamAV 0.97.5/15468/Wed Oct 17 01:13:58 2012\n"

To check Clamd is alive or not.

    Clamd.ping

Response from Clamd daemon will be "PONG" if it is alive

    =>"PONG"

To reload Clamd virus signature database

    Clamd.reload

Response from Clamd daemon will be "RELOADING"

    =>"RELOADING"

To shutdown Clamd daemon

    Clamd.shutdown

Response will be blank if shutdown success
    =>""

To scan a file

    Clamd.scan("/file/path")
    =>"/file/path: OK"

To use CONTSCAN facility of Clamd

    Clamd.contscan("/file/path")
    =>"/file/path: OK"

To use MULTISCAN facility of Clamd

    Clamd.multiscan("/file/path")
    =>"/file/path: OK"

To use INSTREAM facility of Clamd

    Clamd.instream("/file/path/to/stream/to/clamd")
    =>"stream: OK"
    
To know Clamd scan queue status
    Clamd.stats
