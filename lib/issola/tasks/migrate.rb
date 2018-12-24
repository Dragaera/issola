namespace :issola do
  namespace :db do
    # Using a separate table to track migrations will allow users of this gem
    # to create tables of their own, using Sequel's migrations.
    ISSOLA_SEQUEL_SCHEMA_TABLE = :schema_issola

    desc 'Apply DB migrations of Issola up to `version`, all if none specified.'
    task :migrate, [:version] do |t, args|
      # Don't load models when executing DB migrations.
      # This is required, since some of the tables they refer to might not exist
      # yet. It also prevents accidentally using them within migrations - which
      # is asking for trouble anyway.
      ENV['ISSOLA_SKIP_MODELS'] = '1'
      require 'bin/boot'

      # Should ensure it works no matter where the framework is installed - eg if
      # pulled in as a geme.
      migrations_path = File.join(__dir__, '..', '..', '..', 'db', 'migrations')

      Sequel.extension :migration
      db = Sequel::Model.db
      if args[:version]
        Sequel::Migrator.run(db, migrations_path, target: args[:version].to_i, table: ISSOLA_SEQUEL_SCHEMA_TABLE)
      else
        Sequel::Migrator.run(db, migrations_path, table: ISSOLA_SEQUEL_SCHEMA_TABLE)
      end
    end
  end
end
