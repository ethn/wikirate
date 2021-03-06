class Card
  class VegaChart
    module Helper
      # default axis configuration for vega charts
      module Subgroup
        GROUP_PATHS = {
          value_type: "Value_Type.json",
          metric_type: "/Metric_Type+*type+by_create.json"
        }.freeze

        def initialize format, opts={}
          @group = opts[:group] || :value_type
          super
        end

        def hash
          with_values "#{@group}_counts" => 1 do
            super.tap do |h|
              h[:legends] = [builtin(:subgroup_legend)]
              h[:scales] ||= []
              h[:scales] << builtin(:subgroup_scale)
              add_group_data h[:data]
            end
          end
        end

        def filter_data_index
          -1
        end

        def add_group_data data_array
          data_hash = data_array.first
          if GROUP_PATHS.key? @group
            add_data_url data_hash
          else
            add_data_values data_hash
          end
          data_array[filter_data_index][:transform] << filter_transform
        end

        def add_data_url data_hash
          data_hash.merge!(
            url: format.card_url(GROUP_PATHS[@group]),
            format: { property: "items" },
            transform: [{ type: "formula", as: "title", expr: "datum.name" }]
          )
        end

        def add_data_values data_hash
          data_hash[:values] = Answer::VERIFICATION_LEVELS.map.with_index do |h, i|
            h.merge id: i
          end
        end

        def filter_transform
          { type: "formula", as: "filter", expr: "{ #{@group}: datum.group }" }
        end
      end
    end
  end
end
