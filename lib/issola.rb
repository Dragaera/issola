require 'discordrb'

require 'issola/bot'
require 'issola/commands'
require 'issola/module'
require 'issola/models' unless ENV.fetch('ISSOLA_SKIP_MODELS', 0).to_i == 1
require 'issola/user_manager'
require 'issola/server_manager'
require 'issola/version'
