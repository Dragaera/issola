module Issola
  module Commands
    class Event
      attr_reader :event, :positional_arguments

      def initialize(command:, event:, named_arguments:, positional_arguments:)
        @command              = command
        @event                = event
        @named_arguments      = named_arguments
        @positional_arguments = positional_arguments
      end

      def arg(key)
        @named_arguments[key]
      end

      def <<(msg)
        @event << msg
      end
    end
  end
end
