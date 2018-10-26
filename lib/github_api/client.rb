module GithubApi
  class Client
    @@config ||= Configuration.new(GITHUB_API_CONFIG)
    @@client ||= OAuth2::Client.new(@@config.client_id, @@config.client_secret,
                                    @@config.client_opts)

    def self.auth_url
      @@client.auth_code.authorize_url(redirect_uri: @@config.redirect_uri)
    end

    def self.fetch_token(auth_code)
      token = @@client.auth_code.get_token(auth_code, redirect_uri: @@config.redirect_uri)
      CachedToken.where(service: 'github').first_or_initialize.tap do |record|
        record.token = token.token
        record.save
      end
    end

    def self.valid_token?
      endpoint = GithubApi::Endpoints::Endpoint.new
      response = new.send_request_generate_response(endpoint.format_url)
      response.success?
    end

    # Need to have a better error than true. Should store error code
    def send_request_generate_response(endpoint, params = {})
      request = generate_request(endpoint, params)
      @response = GithubApi::Response.new(request: request)
      @response.define_response_and_json

      return @response if @response.status == 200

      @response.add_errors(true)

      @response
    rescue StandardError => e
      @response.add_errors(true)
      @response
    end

    def with_pagination(endpoint)
      Pagination.new(endpoint: endpoint, client: self).with_pagination
    end

    private

    def generate_request(endpoint, params = {})
      token = CachedToken.github&.first&.token
      GithubApi::Request.new(client: @@client, endpoint: endpoint, params: params, headers: default_headers(token))
    end

    def default_headers(token)
      { 'Content-Type' => 'application/x-www-form-urlencoded',
        'Authorization' => "token #{token}" }
    end
  end
end
