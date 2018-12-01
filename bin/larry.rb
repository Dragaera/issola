$LOAD_PATH.unshift '.'
require 'bin/boot'

puts 'Starting Larry the Limpet'

bot = Larry::Bot.new(
  token: Larry::Config::Discord::TOKEN
)

puts "Invite me: #{ bot.invite_url }"
bot.run
