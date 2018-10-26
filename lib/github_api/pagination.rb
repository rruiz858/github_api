module GithubApi
  class Pagination
    attr_accessor :client, :collection, :page

    def initialize(opts = {})
      @client = opts.fetch(:client, GithubApi::Client.new)
      @endpoint = opts[:endpoint]
      @collection = []
      @page = opts.fetch(:page, 1)
      @last_page = nil
    end

    def with_pagination
      loop do
        response = @client.send_request_generate_response(@endpoint, pagination_parameters(page: @page))
        raise 'client error' unless response.success?
        @last_page ||= response.last_page
        @collection += response.body['items']

        break if @page >= @last_page.to_i
        @page += 1

        check_rate_limit(response)
      end
      @collection
    end

    private

    def pagination_parameters(page:)
      params = [GithubApi::Parameters::PerPage.new(value: 100),
                GithubApi::Parameters::Page.new(value: page)]
      params.inject({}) { |aggregate, param| aggregate.merge param.serialize }
    end

    def check_rate_limit(response)
      limit = response.rate_limit
      sleep(60) if limit <= 1
      sleep(5) if limit <= 10
    end
  end
end
