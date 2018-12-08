require 'discordrb'

module Issola
  class Bot
    def initialize(token:, command_prefix:)
      @bot = Discordrb::Bot.new(
        token:     token,
      )

      @command_prefix = command_prefix
      @command_handler = Command::Handler.new

      @bot.message(start_with: @command_prefix) do |event|
        @command_handler.handle(event)
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
