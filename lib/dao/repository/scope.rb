module Dao
  module Repository
    class Scope
      attr_accessor :gateway, :scope

      def initialize(gateway)
        @gateway = gateway
        @scope = gateway.source
        @with = []
      end

      def method_missing(method_name, *args, &block)
        with = extract_with(args)

        add_relations(with) if with.any?

        @scope = @gateway.chain(scope, method_name, args, &block)

        self
      end

      def with(*args)
        add_relations(args)

        self
      end

      def apply
        gateway.map(scope, @with)
      end

      def export_attributes_black_list
        []
      end

      private

      def add_relations(args)
        @scope = @gateway.add_relations(scope, args)
        @with += @gateway.serializable_relations(args)
      end

      def respond_to?(method_name, include_private = false)
        scope.respond_to?(method_name, include_private) || super
      end

      def extract_with(args)
        if have_with_option?(args)
          with = extract_with_option(args)

          Array([with]).flatten.compact
        else
          []
        end
      end

      def have_with_option?(args)
        options = args.last

        options.is_a?(Hash) && options[:with]
      end

      def extract_with_option(args)
        options = args.pop

        options.delete(:with).tap do
          args << options unless options.empty?
        end
      end
    end
  end
end
