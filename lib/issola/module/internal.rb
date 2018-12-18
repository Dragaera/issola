module Issola
  module Module
    class Internal
      SERVER_FORMAT_STRING = "Server count: %d\n%s"
      SERVER_ENTRY_FORMAT_STRING = '- %s (Owner: %s/%s, Member count: %d)'

      def register(handler)
        @handler = handler

        handler.register(
          Commands::Command.new(
            key: :help,
            description: 'Show bot commands',
            positional_usage: '[command]',
            min_pos_args: 0,
            max_pos_args: 1,
            action: method(:cmd_help),
          )
        )

        handler.register(
          Commands::Command.new(
            key: :version,
            description: 'Show bot version',
            action: method(:cmd_version)
          )
        )

        handler.register(
          Commands::Command.new(
            key: :servers,
            description: 'Show servers the bot is in',
            permission: 'internal.servers',
            action: method(:cmd_servers)
          )
        )
      end

      private
      def cmd_help(event)
        pos_args = event.positional_arguments

        if pos_args.empty?
          list_available_commands(event: event)
        else
          show_command_usage(pos_args.first, event: event)
        end
      end

      def list_available_commands(event:)
        event << '**Available commands:**'
        @handler.commands.each do |key, cmd|
          event << "- `#{ key }`: #{ cmd.description }"
        end
      end

      def show_command_usage(key, event:)
        cmd = @handler.commands[key]
        if cmd
          event << cmd.usage_instructions
        else
          event << "No such command: #{ key }"
        end
      end


      def cmd_version(event)
        event << "Version: #{ Issola::VERSION }"
      end


      def cmd_servers(event)
        bot = @handler.bot

        if bot.connected?
          server_entries = bot.servers.map do |_, server|
            SERVER_ENTRY_FORMAT_STRING % [
              server.name,
              server.owner.username,
              server.owner.id,
              server.member_count
            ]
          end
          event << SERVER_FORMAT_STRING % [bot.servers.length, server_entries.join("\n")]
        else
          event << 'Not connected to any servers'
        end
      end
    end
  end
end
