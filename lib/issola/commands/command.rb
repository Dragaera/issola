module Issola
  module Commands
    class Command
      attr_reader :action, :help, :key

      def initialize(
        action: nil,
        help: '(No help available)',
        key:
      )
        self.action = action if action
        @help  = help.to_s
        @key   = key.to_s
      end

      def action=(action)
        raise ArgumentError, '`action` must respond to `#to_proc`' unless action.respond_to? :to_proc
        @action = action.to_proc
      end
    end
  end
end
