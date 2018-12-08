$LOAD_PATH.unshift '.'
require 'bin/boot'

puts 'Starting bot'

bot = Issola::Bot.new(
  token: Issola::Config::Discord::TOKEN
)

puts "Invite me: #{ bot.invite_url }"
bot.run
