require 'optparse'

module Issola
  module Commands
    class Command
      attr_reader :action, :description, :key, :option_parser
      attr_accessor :argument_store

      def initialize(
        action: nil,
        arguments: [],
        description: '(No help available)',
        key:,
        usage: nil
      )
        @usage       = usage.to_s
        @description = description.to_s
        @key         = key.to_s

        @option_parser = OptionParser.new
        @option_parser.banner = "Usage: #{ key } #{ usage || '[options]' }"

        self.action = action if action

        arguments.each do |argument|
          add_argument(*argument)
        end
      end

      def action=(action)
        raise ArgumentError, '`action` must respond to `#to_proc`' unless action.respond_to? :to_proc
        @action = action.to_proc
      end

      def add_argument(key, *args)
        @option_parser.on(*args) do |val|
          @argument_store[key] = val
        end
      end
    end
  end
end
