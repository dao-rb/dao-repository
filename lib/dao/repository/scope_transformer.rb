module Dao
  module Repository
    class ScopeTransformer
      attr_reader :entity
      attr_accessor :associations

      def initialize(entity)
        @entity = entity
        @associations = []
      end

      def many(relation)
        transform(relation)
      end

      def one(relation)
        transform(relation).first
      end

      def export_attributes_black_list
        []
      end

      protected

      def transform(relation, &block)
        Enumerator.new do |collection|
          entities = relation
          entities = relation.collect(&block) if block_given?
          entities.each do |attributes|
            collection << @entity.new(attributes).tap do |entity|
              entity.initialized_with = associations
            end
          end
        end
      end
    end
  end
end

