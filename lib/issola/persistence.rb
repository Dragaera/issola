require 'logger'

require 'sequel'
require 'pg'

module Issola
  module Persistence
    def self.initialize(opts)
      # Needs to be loaded before other extensions, in case they provide custom
      # migration methods, which will only be loaded if the migration extension is loaded.
      Sequel.extension :migration

      # Automated created at / updated at timestamps.
      Sequel::Model.plugin :timestamps

      Sequel::Model.db = Sequel.connect(opts)
      Sequel::Model.db.loggers << Logger.new(STDOUT)
      Sequel::Model.db.extension :pg_enum

      # Have to be loaded after DB connection is set up.
      require 'issola/models' unless ENV.fetch('ISSOLA_SKIP_MODELS', 0).to_i == 1
    end
  end
end
