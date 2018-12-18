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
        cmd.action.call(event)

        return true
      end

      def verify_access(cmd: cmd, event: event, user: user, server: server)
        return true unless cmd.permission

        # User-level permissions on current server, or globally
        if user.permissions(server: [server, DiscordServer.global_server]).first(key: cmd.permission)
          return true
        end

        # Role-based permissions on current server.
        role_ids = event.author.roles.map { |r| r.id.to_s }
        if Permission.first(entity_type: 'role', entity_id: role_ids, discord_server: server, key: cmd.permission)
          return true
        end

        return false
      end
    end
  end
end
