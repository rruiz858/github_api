module GithubApi
  module Parameters
    class Page < Parameter
      def initialize(options = {})
        super
        @name = Parameter::FILTERS[:page]
      end
    end
  end
end
