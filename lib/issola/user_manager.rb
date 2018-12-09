module Issola
  class UserManager
    def track(event)
      DiscordUser.get_or_create(
        event.author.id.to_s,
        last_nick: event.author.display_name
      )
    end
  end
end
