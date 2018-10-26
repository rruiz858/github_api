module GithubApi
  module QueryFilters
    class Stars < Filter
      def initialize(opts = {})
        super
        @name = Filter::FILTERS[:stars]
        @min = opts[:min]
        @max = opts[:max]
      end

      def serialize
        "#{@name}:#{@min}..#{@max}"
      end
    end
  end
end
