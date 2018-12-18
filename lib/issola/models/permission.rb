module Issola
  class Permission < Sequel::Model
    many_to_one :discord_server

    def discord_user
      raise TypeError, 'Permission is not assigned to a user.' unless entity_type == 'user'
      DiscordUser.first(discord_id: entity_id)
    end

    def global?
      discord_server.discord_id == '1' && discord_server.name == 'ISSOLA.GLOBAL'
    end
  end
end
