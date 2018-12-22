module Issola
  module Module
    class Permissions
      Struct.new("Entity", :id, :name)
      # Abusing the fact that the snowflake format used for entity IDs will
      # never be `1` for proper entities.
      EVERYONE_ENTITY_ID = '1'.freeze
      EVERYONE_ENTITY_NAME = 'everyone'.freeze
      EVERYONE_ENTITY = Struct::Entity.new(EVERYONE_ENTITY_ID, 'Everyone')

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
            permission: 'permissions.write',
            action: method(:cmd_grant)
          )
        )

        handler.register(
          Commands::Command.new(
            key: :revoke,
            description: 'Revoke permission from entity',
            positional_usage: '<entity> <permission>',
            min_pos_args: 2,
            max_pos_args: 2,
            arguments: [
              [:global, '-g', '--global', 'Whether to revoke permission globally. If not specified, permission is revoked on current server.'],
            ],
            permission: 'permissions.write',
            action: method(:cmd_revoke)
          )
        )

        handler.register(
          Commands::Command.new(
            key: :permissions,
            description: 'Show permissions of entity',
            positional_usage: '<entity>',
            min_pos_args: 0,
            max_pos_args: 1,
            arguments: [
              [:global, '-g', '--global', 'Whether to show global permissions. If not specified, permission on current server are shown.'],
            ],
            permission: 'permissions.read',
            action: method(:cmd_permissions)
          )
        )

        handler.register(
          Commands::Command.new(
            key: :roles,
            description: 'List roles in current server',
            permission: 'permissions.roles',
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

        if type == :role && global_server
          event << 'Cannot grant permission to role globally.'
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

      def cmd_revoke(event)
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
        perm = Permission.first(opts)

        if perm
          perm.delete
          event << "Revoked `#{ key }` from #{ type } `#{ entity.name }` on #{ server.name }"
        else
          event << 'No such permission granted.'
        end
      end

      def cmd_permissions(event)
        global_server = event.named_arguments[:global]
        entity_id     = event.positional_arguments[0]

        ds = Permission.dataset

        server = if global_server
                   DiscordServer.global_server
                 else
                   event.server
                 end
        ds = ds.where(discord_server: server)

        if entity_id
          type, entity = extract_entity(entity_id, event: event)
          ds = ds.where(entity_type: type.to_s, entity_id: entity.id.to_s)
        end

        if entity_id
          event << "Permissions for #{ type } #{ entity.name } on #{ server.name }:"
        else
          event << "Permissions on #{ server.name }:"
        end

        ds.each do |perm|
          identifier = if perm.entity_id == EVERYONE_ENTITY_ID
                         EVERYONE_ENTITY_NAME
                       else
                         # Preventing lots of user/role lookups if many
                         # permissions around - at the cost of just showing
                         # numeric IDs.
                         perm.entity_id
                       end
          event << "- #{ perm.key } for #{ perm.entity_type } `#{ identifier }`"
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

            event << "- #{ role_name }: `#{ role.id }`"
          end
        else
          event << 'Not on a server.'
        end
      end

      def extract_entity(id, event:)
        return :user, EVERYONE_ENTITY if id == EVERYONE_ENTITY_NAME

        server = event.discordrb_server

        entity = event.bot.parse_mention(id)
        if entity.is_a? Discordrb::User
          return :user, entity
        elsif entity.is_a? Discordrb::Role
          return :role, entity
        elsif entity.nil?
          # If a server is present, we prefer actual entity lookup, as this
          # ensures no typos are made, and we have a proper name to work with.
          if server
            entity = server.member(id)
            return :user, entity if entity

            entity = server.role(id)
            return :role, entity if entity
          end

          # If no server is present, or the entity was not found on the server
          # (because they eg left), we will check if it is a tracked user.
          if (user = DiscordUser.first(discord_id: id))
            return :user, Struct::Entity.new(user.discord_id, user.last_nick)
          end

          # If this failed too, we'll check if the entity is known due to
          # previous permissions.
          if (perm = Permission.first(entity_id: id))
            return perm.entity_type, Struct::Entity.new(perm.entity_id, perm.entity_id)
          end

          # Unknown entity.
          return nil, nil
        end
      end
    end
  end
end
