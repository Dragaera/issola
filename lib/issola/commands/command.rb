require 'optparse'

module Issola
  module Commands
    class Command
      attr_reader :action, :description, :key, :option_parser, :max_pos_args, :min_pos_args, :permission
      attr_accessor :argument_store

      def initialize(
        action: nil,
        arguments: [],
        description: '(No help available)',
        key:,
        max_pos_args: 0,
        min_pos_args: 0,
        permission: nil,
        usage: nil,
        named_usage: nil,
        positional_usage: nil
      )
        @arguments        = arguments
        @usage            = usage
        @positional_usage = positional_usage
        @named_usage      = named_usage
        @description      = description.to_s
        @key              = key.to_s
        @max_pos_args     = Integer(max_pos_args)
        @min_pos_args     = Integer(min_pos_args)
        @permission       = permission

        @option_parser = OptionParser.new
        @option_parser.banner = ''

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

      def usage_instructions
        return @usage if @usage

        usage = []
        usage << '```'

        usage_msg = []
        usage_msg << "Usage: #{ key }"

        unless @named_usage || @arguments.empty?
          usage_msg << "[options]"
        end

        if @positional_usage
          usage_msg << @positional_usage
        else
          if @max_pos_args > 0
            usage_msg += @min_pos_args.times.map { |i| "<arg#{ i }>" }
            usage_msg += (@max_pos_args- @min_pos_args).times.map { |i| "[arg#{ i + @min_pos_args }]" }
          end
        end

        usage << usage_msg.join(' ')

        if @named_usage
          usage << @named_usage
        else
          unless @arguments.empty?
            # Includes a linebreak between (empty) banner and argument
            # descriptions.
            usage << @option_parser.to_s.gsub(/^\n/, '')
          end
        end

        usage << '```'

        return usage.join("\n")
      end
    end
  end
end
