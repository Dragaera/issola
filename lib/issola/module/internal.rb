module Issola
  module Module
    class Internal
      def register(handler)
        @handler = handler

        handler.register(
          Commands::Command.new(
            key: :help,
            help: 'Show bot commands',
            action: method(:cmd_help)
          )
        )

        handler.register(
          Commands::Command.new(
            key: :version,
            help: 'Show bot version',
            action: method(:cmd_version)
          )
        )
      end

      private
      def cmd_help(cmd_event)
        cmd_event << '**Available commands:**'
        @handler.commands.each do |key, cmd|
          cmd_event << "- `#{ key }`: #{ cmd.help }"
        end
      end

      def cmd_version(cmd_event)
        cmd_event << "Version: #{ Issola::VERSION }"
      end
    end
  end
end
