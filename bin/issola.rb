$LOAD_PATH.unshift '.'
require 'bin/boot'

puts 'Starting bot'

bot = Issola::Bot.new(
  token: ENV.fetch('DISCORD_TOKEN'),
  command_prefix: '!'
)

bot.register(Issola::Module::Internal.new)

puts "Invite me: #{ bot.invite_url }"
bot.run
