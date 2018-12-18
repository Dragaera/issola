module Issola
  module Commands
    class Event
      attr_reader :event, :positional_arguments, :server, :user

      def initialize(command:, event:, named_arguments:, positional_arguments:, server:, user:)
        @command              = command
        @event                = event
        @named_arguments      = named_arguments
        @positional_arguments = positional_arguments
        @server               = server
        @user                 = user
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
