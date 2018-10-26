module GithubApi
  module Endpoints
    class Endpoint
      attr_accessor :url, :query_filters
      ENPOINTS = { repositories: 'https://api.github.com/search/repositories' }.freeze

      def initialize(opts = {})
        @url = opts.fetch(:url, 'https://api.github.com')
        @query_filters = opts[:query_filters]
      end

      def format_url
        "#{@url}#{format_get_query_params}".strip
      end

      private

      def format_get_query_params
        return unless @query_filters
        str = '?q='
        Array.wrap(@query_filters).each_with_index do |filter, i|
          str << if i == @query_filters.size - 1
                   filter.serialize
                 else
                   filter.serialize + '+'
                 end
        end
        str
      end
    end
  end
end
