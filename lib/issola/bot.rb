require 'discordrb'

module Issola
  class Bot
    def initialize(token:)
      @bot = Discordrb::Bot.new(
        token:     token,
      )

      @command_handler = Command::Handler.new

      @bot.message(start_with: Config::Bot::COMMAND_PREFIX) do |event|
        puts "Got message: #{ event.message }"
      end
    end

    def invite_url
      @bot.invite_url
    end

    def register(obj)
      obj.register(@command_handler)
    end

    def run
      @bot.run
    end
  end
end
