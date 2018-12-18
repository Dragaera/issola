module Issola
  class UserManager
    def track(event)
      current_nick = if event.server
                       event.author.display_name
                     else
                       event.author.username
                     end

      DiscordUser.get_or_create(
        event.author.id.to_s,
        last_nick: event.author.username
      )
    end
  end
end
