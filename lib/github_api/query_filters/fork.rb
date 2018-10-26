module GithubApi
  module QueryFilters
    class Fork < Filter
      def initialize(opts= {})
        super
        @name = Filter::FILTERS[:fork]
      end
    end
  end
end
