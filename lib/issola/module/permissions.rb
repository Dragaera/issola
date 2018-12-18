module Issola
  module Module
    class Permissions
      def register(handler)
        @handler = handler

        handler.register(
          Commands::Command.new(
            key: :grant,
            description: 'Grant permission to entity',
            positional_usage: '<entity> <permission>',
            min_pos_args: 2,
            max_pos_args: 2,
            arguments: [
              [:global, '-g', '--global', 'Whether to grant permission globally. If not specified, permission is granted on current server.'],
            ],
            action: method(:cmd_grant)
          )
        )

        handler.register(
          Commands::Command.new(
            key: :roles,
            description: 'List roles in current server',
            action: method(:cmd_roles)
          )
        )
      end

      private
      def cmd_grant(event)
        global_server  = event.named_arguments[:global]
        entity_id, key = event.positional_arguments

        type, entity = extract_entity(entity_id, event: event)

        if entity.nil?
          event << "No such entity: `#{ entity_id }`"
          return false
        end

        server = if global_server
                   DiscordServer.global_server
                 else
                   event.server
                 end

        if server.nil?
          event << "No such server: #{ server_id }"
          return false
        end

        opts = {
          entity_id:      entity.id.to_s,
          entity_type:    type.to_s,
          key:            key,
          discord_server: server
        }
        if Permission.first(opts)
          event << 'Permission already granted.'
        else
          Permission.create(opts)
          event << "Granted `#{ key }` to #{ type } `#{ entity.name }` on #{ server.name }"
        end
      end

      def cmd_roles(event)
        if event.discordrb_server
          event << "Roles on #{ event.discordrb_server.name }:"
          event.discordrb_server.roles.each do |role|
            # Thanks Discord
            role_name = if role.name == '@everyone' then
                          '@.everyone'
                        else
                          role.name
                        end

            event << "- #{ role_name }: #{ role.id }"
          end
        else
          event << 'Not on a server.'
        end
      end

      def extract_entity(id, event:)
        server = event.discordrb_server

        entity = event.bot.parse_mention(id)
        if entity.is_a? Discordrb::User
          return :user, entity
        elsif entity.is_a? Discordrb::Role
          return :role, entity
        elsif entity.nil?
          entity = server.member(id)
          return :user, entity if entity

          entity = server.role(id)
          return :role, entity if entity

          return nil, nil
        end
      end
    end
  end
end
