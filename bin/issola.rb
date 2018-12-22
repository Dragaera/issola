$LOAD_PATH.unshift '.'
require 'bin/boot'

puts 'Starting bot'

bot = Issola::Bot.new(
  token: ENV.fetch('DISCORD_TOKEN'),
  admin_users: [ENV.fetch('ADMIN_USER')],
  command_prefix: '!'
)

bot.register(Issola::Module::Internal.new)
bot.register(Issola::Module::Permissions.new)

puts "Invite me: #{ bot.invite_url }"
bot.run
