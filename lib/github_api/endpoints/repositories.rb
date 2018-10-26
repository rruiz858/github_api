module GithubApi
  module Endpoints
    class Repositories < Endpoint
      def initialize(opts = {})
        super
        @url = Endpoint::ENPOINTS[:repositories]
      end
    end
  end
end
