module Issola
  module Command
    class Builder
      def key(key)
        @key = key.to_s
      end

      def action(&blk)
        @action = blk
      end

      def command
        raise ArgumentError, 'Unable to build command, missing attributes' unless valid?

        Command.new(key: @key, action: @action)
      end

      def valid?
        @key && @action
      end
    end
  end
end
