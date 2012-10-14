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

## Usage

    To know Clamd version
      Clamd.version
    To check Clamd is alive or not
      Clamd.ping
    To reload Clamd virus signature database
      Clamd.reload
    To shutdown Clamd
      Clamd.shutdown
    To scan a file
      Clamd.scan(full_file_or_directory_path)
    To use CONTSCAN facility of Clamd
      Clamd.contscan(full_file_or_directory_path)
    To use MULTISCAN facility of Clamd
      Clamd.multiscan(full_file_or_directory_path)
    To use INSTREAM facility of Clamd
      Clamd.instream(full_file_path)
    To know Clamd scan queue status
      Clamd.stats
