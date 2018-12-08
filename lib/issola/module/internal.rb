module Issola
  module Module
    class Internal
      def register(handler)
        @handler = handler

        handler.register(
          Commands::Command.new(
            key: :help,
            description: 'Show bot commands',
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
          event << cmd.option_parser.help
        else
          event << "No such command: #{ key }"
        end
      end

      def cmd_version(event)
        event << "Version: #{ Issola::VERSION }"
      end
    end
  end
end
