require 'discordrb'

module Larry
  class Bot
    def initialize(token:)
      @bot = Discordrb::Bot.new(
        token:     token,
      )
    end

    def invite_url
      @bot.invite_url
    end

    def run
      @bot.run
    end
  end
end
