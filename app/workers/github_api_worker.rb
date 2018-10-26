class GithubApiWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'github_api', retry: false

  sidekiq_retries_exhausted do |msg, _e|
    Sidekiq.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
  end

  # Due to the 30 requests per minute and the 1000 limit on each requests, the quickest (and dirtiest) way to
  # make sure we get all of the records without running out of request per minute it to
  # 1) Run a job per a 24 hour strech
  # 2) Perform method will recursively call itself
  # 3) The response will be delayed if pagination is needed
  # There needs to be logic that accounts to when the total count of request comes back as greater than 1000..
  # Though, Splitting it up by a an hour basis seems helps with keeping the total count to less than the limit the GithubApi has
  def perform(opts)
    client = GithubApi::Client.new
    opts = opts.with_indifferent_access
    determine_times(opts)
    endpoint = GithubApi::Endpoints::Repositories.new(query_filters(opts)).format_url

    collection = client.with_pagination(endpoint)

    calculate_totals_by_stars(collection)

    next_job(opts)

    calculate_totals_by_stars(collection).each do |total|
      Calculation.where(min_range: total[:min_range], max_range: total[:max_range]).first_or_initialize.tap do |calculation|
        count = calculation.projects_count.to_i
        calculation.projects_count = count += total[:projects_count]
        calculation.is_finished_calculating = true if opts[:counter] >= opts[:max]
        calculation.save
      end
    end
    collection.each do |item|
      Project.where(github_id: item['id']).first_or_initialize.tap do |project|
        project.name = item['name']
        project.url = item['url']
        project.stars = item['stargazers_count']
        project.owner = item.dig('owner', 'login') # Should this be a json blob object? 
        project.save
      end
    end
  end

  private

  def query_filters(opts)
    { query_filters: [GithubApi::QueryFilters::Fork.new(value: false),
                      GithubApi::QueryFilters::Language.new(value: 'Ruby'),
                      GithubApi::QueryFilters::Language.new(value: 'JavaScript'),
                      GithubApi::QueryFilters::License.new(value: 'apache-2.0'),
                      GithubApi::QueryFilters::License.new(value: 'gpl'),
                      GithubApi::QueryFilters::License.new(value: 'lgpl'),
                      GithubApi::QueryFilters::License.new(value: 'mit'),
                      GithubApi::QueryFilters::License.new(value: 'mit'),
                      GithubApi::QueryFilters::Pushed.new(min: opts[:start_time], max: opts[:end_time]),
                      GithubApi::QueryFilters::Stars.new(min: 1, max: 2000)] }
  end

  def calculate_totals_by_stars(collection)
    results = []
    (1..2000).step(200) do |n|
      min_range = n
      max_range = ((n / 200.0).ceil * 200)
      count = collection.select { |record| record['stargazers_count'].to_i.between?(min_range, max_range) }.size
      results << { min_range: min_range, max_range: max_range, projects_count: count }
    end
    results
  end

  def determine_times(opts)
    start_time = opts[:end_time] ? Time.parse(opts[:end_time]) : Time.parse(opts[:start_time])
    opts.merge!(start_time: start_time.beginning_of_hour.to_s,
                end_time: (start_time.end_of_hour + 1.hour).to_s,
                counter: opts[:counter] += 1,
                perform_in: Time.now + 2.seconds)
  end

  def next_job(opts)
    GithubApiWorker.perform_at(opts[:perform_in], opts) if opts[:counter] <= opts[:max]
  end
end
