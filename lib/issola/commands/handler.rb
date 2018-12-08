module Issola
  module Commands
    class Handler
      attr_reader :commands

      def initialize(command_prefix:)
        @command_prefix = command_prefix
        @commands = {}
      end

      def register(command)
        @commands[command.key] = command
      end

      def handle(event)
        # Remove command prefix
        msg = event.message.content[@command_prefix.length..-1]
        tokens = msg.split(' ')
        cmd_key = tokens.shift
        args = tokens.join(' ')

        cmd = @commands[cmd_key]
        if cmd
          handle_command(cmd: cmd, arg_string: args, event: event)
        end
      end

      private
      def handle_command(cmd:, arg_string:, event:)
        cmd.action.call(event)
      end
    end
  end
end
