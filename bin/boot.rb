# This file is intended to be used to set up your environment *when you are
# working on this gem.*
# If you are simply creating a bot based on this gem, chances are a simple
# `require 'issola'` is what you want.

$LOAD_PATH.unshift 'lib'

APPLICATION_ENV = ENV.fetch('APPLICATION_ENV', 'development')

if APPLICATION_ENV == 'development'
  require 'dotenv'
  require 'rake'
  require 'pry'
  require 'warning'
end

if Object.const_defined?(:Warning)
  # Ignore all warnings about uninitialized instane variables, as `sequel`
  # generates plenty of those.
  Warning.ignore(/instance variable @\w+ not initialized/)
end

# Not limiting to specific environments, as we don't know which envs it might be used in.
if Object.const_defined?(:Dotenv)
  env_file = ".env.#{ APPLICATION_ENV }"
  puts "Loading env-specific env variables from #{ env_file }"
  Dotenv.load env_file
else
  puts 'Dotenv not available, skipping.'
end

require 'issola'

Issola::Persistence.initialize(
  {
    adapter: 'postgres',
    host:     ENV.fetch('DB_HOST'),
    port:     ENV.fetch('DB_PORT').to_i,
    database: ENV.fetch('DB_DATABASE'),
    user:     ENV.fetch('DB_USER'),
    password: ENV.fetch('DB_PASSWORD'),
    test:     true,
  }
)
