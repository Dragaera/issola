$LOAD_PATH.unshift '.'
require 'bin/boot'

class InternalCommands
  def register(cmd_handler)
    cmd_handler.register do |cmd|
      cmd.key :help
      cmd.action do |event|
        puts "Starting command :)"
        event << 'Help help!'
      end
    end

    cmd_handler.register do |cmd|
      cmd.key :version
      cmd.action do |event|
        event << "Issola version: #{ Issola::VERSION }"
      end
    end
  end
end

puts 'Starting bot'

bot = Issola::Bot.new(
  token: ENV.fetch('DISCORD_TOKEN'),
  command_prefix: '!'
)

bot.register(InternalCommands.new)

puts "Invite me: #{ bot.invite_url }"
bot.run
