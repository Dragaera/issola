module Issola
  module Command
    class Handler
      def initialize
        @commands = {}
      end

      def register
        builder = Builder.new

        yield builder
        raise ArgumentError, 'Unable to register command, required attribute(s) missing.' unless builder.valid?

        cmd = builder.command
        @commands[cmd.key] = cmd
      end

      def handle(event)
        tokens = event.message.content.split(' ')
        puts "Checking for command in message: #{ tokens.inspect }"

        # Get rid of command prefix
        key = tokens.first[1..-1]
        cmd = @commands[key]
        if cmd
          puts "Found command!"
          cmd.action.call(event)
        end
      end
    end
  end
end
