require 'discordrb'

module Issola
  class Bot
    attr_reader :user_manager, :server_manager, :admin_users

    def initialize(token:, command_prefix:, admin_users: [])
      @bot = Discordrb::Bot.new(
        token:     token,
      )

      @user_manager = UserManager.new
      @server_manager = ServerManager.new

      @admin_users = Set.new(admin_users).freeze

      @command_handler = Commands::Handler.new(
        bot: self,
        command_prefix: command_prefix
      )

      @bot.message do |event|
        puts "Got message: #{ event.message.content.inspect }"
        @command_handler.handle_message(
          event: event,
          user: @user_manager.track(event),
          server: @server_manager.track(event)
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
