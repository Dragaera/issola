module Issola
  module Command
    class Command
      attr_reader :key, :action

      def initialize(key:, action:)
        @key    = key
        @action = action
      end
    end
  end
end
