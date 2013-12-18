module Clamd
  module Commands
    COMMAND = {
      ping:       'PING',
      version:    'VERSION',
      reload:     'RELOAD',
      shutdown:   'SHUTDOWN',
      scan:       'SCAN',
      contscan:   'CONTSCAN',
      multiscan:  'MULTISCAN',
      instream:   'zINSTREAM\0',
      stats:      'zSTATS\0'
    }.freeze
  end
end
