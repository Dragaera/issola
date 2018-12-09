require 'discordrb'

require 'issola/bot'
require 'issola/commands'
require 'issola/module'
unless ENV.fetch('ISSOLA_SKIP_MODELS', 0).to_i == 1
  require 'issola/models'
end
require 'issola/version'
