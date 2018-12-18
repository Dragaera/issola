module Issola
  class DiscordServer < Sequel::Model
    def self.get_or_create(discord_id:, name:)
      server = first(discord_id: discord_id)
      if server
        server.update(name: name)

        server
      else
        DiscordServer.create(discord_id: discord_id, name: name)
      end
    end
  end
end
