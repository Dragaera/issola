module Issola
  module Commands
    class Handler
      attr_reader :commands, :bot

      def initialize(bot:, command_prefix:)
        @bot = bot
        @command_prefix = command_prefix
        @commands = {}
      end

      def register(command)
        @commands[command.key] = command
      end

      def handle_message(event:, user:, server:)
        msg = event.message.content
        return false unless msg.start_with? @command_prefix 
        # Remove command prefix
        msg = msg[@command_prefix.length..-1]
        args = msg.split(' ')
        cmd_key = args.shift

        cmd = @commands[cmd_key]
        if cmd
          handle_command(cmd: cmd, args: args, event: event, user: user, server: server)
        end
      end

      private
      def handle_command(cmd:, args:, event:, user:, server:)
        named_arguments = {}
        cmd.argument_store = named_arguments
        opt = cmd.option_parser

        unless verify_access(cmd: cmd, event: event, user: user, server: server)
          event << "You are not allowed to perform this action. Required permission: `#{ cmd.permission }`."
          return false
        end

        begin
          opt.parse!(args)
        rescue OptionParser::InvalidOption
          event << cmd.usage_instructions
          return false
        end

        # Support eg quoating multiple words, for them to be treated as one
        # argument.
        arg_string = args.join(' ')
        args = arg_string.shellsplit
        unless args.length.between?(cmd.min_pos_args, cmd.max_pos_args)
          event << cmd.usage_instructions
          return false
        end

        event = Event.new(
          command: cmd,
          event: event,
          named_arguments: named_arguments,
          positional_arguments: args,
          server: server,
          user: user
        )

        unless cmd.action.call(event)
          event << cmd.usage_instructions
          return false
        end

        return true
      end

      def verify_access(cmd:, event:, user:, server:)
        return true unless cmd.permission

        return true if @bot.admin_users.include? user.discord_id

        # 'Everyone' permissions on current server, or globally
        if Permission.first(
            entity_type: 'user',
            entity_id: Module::Permissions::EVERYONE_ENTITY_ID,
            discord_server: [server, DiscordServer.global_server],
            key: cmd.permission
        )
          return true
        end

        # User-level permissions on current server, or globally
        if user.permissions(discord_server: [server, DiscordServer.global_server]).first(key: cmd.permission)
          return true
        end

        # Role-based permissions on current server.
        role_ids = event.author.roles.map { |r| r.id.to_s }
        if Permission.first(
            entity_type: 'role',
            entity_id: role_ids,
            discord_server: server,
            key: cmd.permission
        )
          return true
        end

        return false
      end
    end
  end
end
