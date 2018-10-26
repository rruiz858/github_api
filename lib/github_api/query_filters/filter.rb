module GithubApi
  module QueryFilters
    class Filter
      attr_accessor :name, :value

      FILTERS = { stars: 'stars',
                  pushed: 'pushed',
                  fork: 'fork',
                  language: 'language',
                  license: 'license' }.freeze
      def initialize(opts= {})
        @name = opts[:name]
        @value = opts[:value]
        @condition = opts[:condition]
      end

      def serialize
        [@name, @value].join(':')
      end
    end
  end
end
