module Issola
  class ServerManager
    def track(event)
      return DiscordServer.global_server unless event.server

      DiscordServer.get_or_create(
        discord_id: event.server.id.to_s,
        name: event.server.name
      )
    end
  end
end
