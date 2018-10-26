module GithubApi
  module Parameters
    class Parameter
      attr_accessor :name, :value

      FILTERS = { per_page: 'per_page', page: 'page' }.freeze
      def initialize(options = {})
        @name = options[:name]
        @value = options[:value]
      end

      def serialize
        { @name => @value }.as_json
      end
    end
  end
end
