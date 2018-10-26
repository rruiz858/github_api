module GithubApi
  module QueryFilters
    class Pushed < Filter
      attr_accessor :min, :max
      def initialize(opts = {})
        super
        @name = Filter::FILTERS[:pushed]
        @min = format_time(opts[:min])
        @max = format_time(opts[:max])
      end

      def serialize
        "#{@name}:#{@min}..#{@max}"
      end

      private

      def format_time(time)
        Time.parse(time).strftime('%Y-%m-%dT%H:%M:%SZ')
      end
    end
  end
end
