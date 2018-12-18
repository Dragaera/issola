module Issola
  module Commands
    class Event
      attr_reader :named_arguments, :positional_arguments, :server, :user

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

      def discordrb_server
        @event.server
      end

      def method_missing(m, *args, &block)
        # Buggers used :send as an alias for :send_method
        @event.__send__(m, *args, &block)
      end
    end
  end
end
