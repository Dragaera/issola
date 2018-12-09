require 'discordrb'

module Issola
  class Bot
    def initialize(token:, command_prefix:)
      @bot = Discordrb::Bot.new(
        token:     token,
      )

      @user_manager = UserManager.new

      @command_handler = Commands::Handler.new(
        bot: self,
        command_prefix: command_prefix
      )

      @bot.message do |event|
        @command_handler.handle_message(
          event: event,
          user: @user_manager.track(event)
        )
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
