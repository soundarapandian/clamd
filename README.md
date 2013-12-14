# Clamd

Ruby gem to speak with Clamd daemon

## Installation

Add this line to your application's Gemfile:

    gem 'clamd'

And then execute:

    $ bundle

Install clamd directly

    $ gem install clamd

## Configuration

Clamd by default connects to 9321 port in localhost. You can also configure the
host, port, open_timeout(seconds), read_timeout(seconds) and chunk_size(bytes).
Refer the following code to configure Clamd.
    
    @client.configure do |config|
      config.host = 'localhost'
      config.port = 9321
      config.open_timeout = 5
      config.read_timeout = 20
      config.chunk_size = 102400
    end  

## Usage

    @client = Clamd::Client.new

### PING

    @client.ping
    =>"PONG"

### RELOAD

    @client.reload
    =>"RELOADING"

### SHUTDOWN

    @client.shutdown
    =>""

### SCAN

    @client.scan("/file/path")
    =>"/file/path: OK"

### CONTSCAN

    @client.contscan("/file/path")
    =>"/file/path: OK"

### MULTISCAN

    @client.multiscan("/file/path")
    =>"/file/path: OK"

### INSTREAM

    @client.instream("/file/path/to/stream/to/clamd")
    =>"stream: OK"
    
### STATS

    @client.stats
    => "POOLS: 1STATE: VALID PRIMARYTHREADS: live 1  idle 0 max 12 idle-timeout 30QUEUE: 0 items"


### VERSION

    @client.version
    => "ClamAV 0.97.8/18237/Sat Dec 14 11:13:16 2013"

## Test

Run spec

    rspec spec/
