module GithubApi
  module QueryFilters
    class License < Filter
      def initialize(opts = {})
        super
        @name = Filter::FILTERS[:license]
      end
    end
  end
end
