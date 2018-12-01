$LOAD_PATH.unshift 'lib'

APPLICATION_ENV = ENV.fetch('APPLICATION_ENV', 'development')

require 'bundler'
Bundler.require(:default, APPLICATION_ENV)

# Ignore all warnings about uninitialized instane variables, as `sequel`
# generates plenty of those.
Warning.ignore(/instance variable @\w+ not initialized/)

# Not limiting to specific environments, as we don't know which envs it might be used in.
if Object.const_defined?(:Dotenv)
  env_file = ".env.#{ APPLICATION_ENV }"
  puts "Loading env-specific env variables from #{ env_file }"
  Dotenv.load env_file
else
  puts 'Dotenv not available, skipping.'
end

require 'larry'
