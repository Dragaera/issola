module Issola
  module Commands
    class Event
      def initialize(key:, named_arguments: {}, positional_arguments: [])
        @key                  = key
        @named_arguments      = named_arguments
        @positional_arguments = positional_arguments
      end
    end
  end
end
