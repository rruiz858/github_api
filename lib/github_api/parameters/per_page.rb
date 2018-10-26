module GithubApi
  module Parameters
    class PerPage < Parameter
      def initialize(options = {})
        super
        @name = Parameter::FILTERS[:per_page]
      end
    end
  end
end
