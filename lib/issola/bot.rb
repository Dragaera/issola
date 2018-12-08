require 'discordrb'

module Issola
  class Bot
    def initialize(token:, command_prefix:)
      @bot = Discordrb::Bot.new(
        token:     token,
      )

      @command_handler = Commands::Handler.new(
        bot: self,
        command_prefix: command_prefix
      )

      @bot.message(start_with: command_prefix) do |event|
        @command_handler.handle(event)
      end
    end

    def register(obj)
      obj.register(@command_handler)
    end

    def connected?
      @bot.connected?
    end

    def invite_url
      @bot.invite_url
    end

    def run
      @bot.run
    end

    def servers
      @bot.servers
    end
  end
end
