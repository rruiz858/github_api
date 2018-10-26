module GithubApi
  module QueryFilters
    class Language < Filter
      def initialize(opts = {})
        super
        @name = Filter::FILTERS[:language]
      end
    end
  end
end
