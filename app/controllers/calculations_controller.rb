class CalculationsController < ApplicationController
  before_action :check_token, only: [:index]
  before_action :load_calculations
  before_action :call_github_service, only: [:index]

  def index; end

  def count_by_stars
    render json: @calculations, status: 200
  end

  private

  def load_calculations
    @calculations = Calculation.order(id: :asc)
  end

  def call_github_service
    GithubApiEnqueueService.new.call
  end
end
