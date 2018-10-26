module GithubApi
  class Response
    attr_accessor :request, :response, :errors

    def initialize(opts = {})
      @request = opts[:request]
      @errors = []
    end

    def define_response_and_json
      @response = @request.call if @response.nil?
      g_json if @json.nil?
    end

    def headers
      !@response.nil? ? @response.headers : nil
    end

    def body
      !@response.nil? ? g_json : nil
    end

    def add_errors(error)
      @errors.push(error)
    end

    def success?
      return nil if @response.nil?

      @errors.to_a.empty? ? true : false
    end

    def g_json
      return @json if @json

      json(parse_json(@response.body)) unless @response.to_s.nil?
    end

    def status
      !@response.nil? ? @response.status : nil
    end

    def rate_limit
      !@response.nil? ? headers.dig('x-ratelimit-remaining').to_i : nil
    end

    def last_page
      @last_page ||= get_last_page
    end

    def get_last_page
      return nil unless headers

      return nil unless (link = headers['link'])

      urls = link.split('",')
      return 0 unless (url = urls.detect { |i| i =~ /rel="last"/ })
      url[/(\?|&)page=(\d+)/].delete('^0-9')
    end

    private

    def parse_json(body)
      JSON.parse(body)
    rescue StandardError
      nil
    end

    def json(json)
      @json = json
    end
  end
end
