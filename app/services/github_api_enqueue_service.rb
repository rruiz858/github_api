class GithubApiEnqueueService
  def call
    delete_projects
    zero_out_calculations
    clear_current_jobs
    job = prepare_job
    GithubApiWorker.perform_async(job)
  end

  private

  def zero_out_calculations
    Calculation.update_all(projects_count: nil, is_finished_calculating: nil)
  end

  def delete_projects
    Project.delete_all
  end

  def prepare_job
    start = Time.now - 1 .day
    { start_time: start.to_s,
      max: 24,
      counter: 0 }
  end

  def clear_current_jobs
    Sidekiq.redis { |conn| conn.flushdb }
  end
end
