module GithubApi
  class Request
    attr_accessor :client, :endpoint, :params, :headers

    def initialize(opts = {})
      @client = opts.fetch(:client, GithubApi::Client.new)
      @endpoint = opts[:endpoint]
      @params = opts.fetch(:params, {})
      @headers = opts.fetch(:headers, {})
    end

    def call
      @client.request(:get, @endpoint, { params: @params, headers: @headers })
    end
  end
end
