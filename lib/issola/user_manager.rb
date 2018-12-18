module Issola
  class UserManager
    def track(event)
      current_nick = if event.server
                       event.author.display_name
                     else
                       nil
                     end

      DiscordUser.get_or_create(
        event.author.id.to_s,
        last_nick: current_nick
      )
    end
  end
end
