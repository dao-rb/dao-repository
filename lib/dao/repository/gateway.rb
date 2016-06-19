module Dao
  module Repository
    class Gateway
      attr_reader :source, :transformer

      def initialize(source, transformer)
        @source = source
        @transformer = transformer

        @black_list_attributes = @transformer.export_attributes_black_list
      end

      def map(object, associations)
        import(object, associations)
      end

      def save!(_domain, _attributes)
        fail 'not implemented'
      end

      def chain(_scope, _method_name, _args, &_block)
        fail 'not implemented'
      end

      def add_relations(*)
        raise RelationsNotSupported
      end

      def with_transaction(&_block)
        raise TransactionNotSupported
      end

      def serializable_relations(relations)
        convert_array(relations)
      end

      protected

      def export(_base, _record = nil)
        fail 'not implemented'
      end

      def import(_relation, _associations)
        fail 'not implemented'
      end

      def record(_domain_id)
        fail 'not implemented'
      end

      def convert_array(array)
        array.collect do |value|
          if value.is_a? Hash
            convert_hash(value)
          else
            value
          end
        end
      end

      def convert_hash(hash)
        hash.each_with_object({}) do |(key, value), new_hash|
          new_hash[key] =
            if value.is_a? Array
              { include: convert_array(value) }
            elsif value.is_a? Hash
              { include: convert_hash(value) }
            else
              { include: value }
            end
        end
      end
    end
  end
end
