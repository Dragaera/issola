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
    end
  end
end
