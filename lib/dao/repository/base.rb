module Dao
  module Repository
    class Base
      class << self
        def entity(entity)
          @entity = entity
        end

        def gateway(gateway = nil, source = nil, transformer = nil)
          if gateway && source && transformer
            @gateway = gateway
            @source = source
            @transformer = transformer
          else
            @gateway.new(@source, @transformer.new(@entity))
          end
        end

        def all
          scope.all.apply
        end

        def find(id, with: nil)
          attributes = {}
          attributes[:with] = with if with
          scope.find(id, attributes).apply
        end

        def find_by_id(id)
          scope.find_by_id(id).apply
        end

        def last(with: nil)
          attributes = {}
          attributes[:with] = with if with
          scope.last(attributes).apply
        end

        def count
          scope.count.apply
        end

        def build(record = nil)
          gateway.map(record, {})
        end

        def save(domain, attributes = {})
          gateway.save!(domain, attributes)
        end

        def save_all(domains)
          with_transaction do
            domains.map { |domain| save(domain) }
          end
        end

        def delete(domain)
          delete_by_id(domain.id) if domain
        end

        def delete_by_id(domain_id)
          gateway.delete(domain_id)
        end

        def with_transaction(&block)
          gateway.with_transaction(&block)
        end

        def by_criteria(criteria)
          criteria.filter(scope).apply
        end

        def by_criteria_count(criteria)
          criteria.count_of_result_items(scope).apply
        end

        protected

        def scope
          Scope.new(gateway)
        end
      end
    end
  end
end
