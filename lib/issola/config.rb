module Issola
  module Config
    module Discord
      TOKEN = ENV.fetch('DISCORD_TOKEN')
    end

    module Bot
      COMMAND_PREFIX = ENV.fetch('BOT_COMMAND_PREFIX', '!')
    end
  end
end
