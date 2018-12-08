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

      def handle(event)
        # Remove command prefix
        msg = event.message.content[@command_prefix.length..-1]
        args = msg.split(' ')
        cmd_key = args.shift

        cmd = @commands[cmd_key]
        if cmd
          handle_command(cmd: cmd, args: args, event: event)
        end
      end

      private
      def handle_command(cmd:, args:, event:)
        named_arguments = {}
        cmd.argument_store = named_arguments
        opt = cmd.option_parser

        begin
          opt.parse!(args)
        rescue OptionParser::InvalidOption
          event << opt.help
          return false
        end

        unless args.length.between?(cmd.min_pos_args, cmd.max_pos_args)
          event << opt.help
          return false
        end

        event = Event.new(
          command: cmd,
          event: event,
          named_arguments: named_arguments,
          positional_arguments: args
        )
        cmd.action.call(event)

        return true
      end
    end
  end
end
