module GithubApi
  class Configuration
    CLIENT_OPTIONS = %i[site ssl authorize_url token_url token_method connection_opts
                        connection_build max_redirects raise_errors].freeze

    attr_accessor :client_id, :client_secret, :redirect_uri, :scope, *CLIENT_OPTIONS

    def initialize(opts)
      opts.each do |k, v|
        public_send("#{k}=".to_sym, v)
      end
    end

    def client_opts
      CLIENT_OPTIONS.inject({}) do |memo, opt|
        memo.tap { |m| m[opt] = public_send(opt) }
      end.compact
    end

    def client_opts=(opts)
      opts.each do |k, v|
        public_send("#{k}=".to_sym, v)
      end
    end
  end
end
