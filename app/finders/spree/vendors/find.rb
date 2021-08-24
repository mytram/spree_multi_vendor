module Spree
  module Vendors
    class Find
      def initialize(scope:, params:)
        @scope = scope

        @ids = String(params.dig(:filter, :ids)).split(',')
        @name = params.dig(:filter, :name)

        @sort_by = params.dig(:sort_by)
      end

      def execute
        vendors = by_ids(scope)
        vendors = by_name(vendors)
        vendors = ordered(vendors)

        vendors.distinct
      end

      private

      attr_reader :ids, :name, :scope, :sort_by

      def ids?
        ids.present?
      end

      def name?
        name.present?
      end

      def sort_by?
        sort_by.present?
      end

      def by_ids(vendors)
        return vendors unless ids?

        vendors.where(id: ids)
      end

      def by_name(vendors)
        return vendors unless name?

        vendors.like_any([:name], [name])
      end

      def ordered(vendors)
        return vendors unless sort_by?

        case sort_by
        when 'name-a-z'
          vendors.order(name: :asc)
        when 'name-z-a'
          vendors.order(name: :desc)
        when 'newest-first'
          vendors.order(created_at: :desc)
        end
      end
    end
  end
end
