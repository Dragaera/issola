module Issola
  class DiscordUser < Sequel::Model
    def self.get_or_create(discord_id, last_nick: nil)
      user = first(discord_id: discord_id)
      if user
        user.update(last_nick: last_nick) if last_nick

        user
      else
        raise ArgumentError, 'Must supply nickname when creating user' unless last_nick
        DiscordUser.create(discord_id: discord_id, last_nick: last_nick)
      end
    end

    def permissions(discord_server: nil)
      ds = Permission.where(
        entity_type: 'user',
        entity_id: discord_id
      )

      ds = ds.where(discord_server: discord_server) if discord_server

      ds
    end
  end
end
