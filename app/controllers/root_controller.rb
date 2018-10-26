class RootController < ApplicationController
  before_action :auth_code

  def welcome
    @github_url = GithubApi::Client.auth_url
  end

  def callback
    GithubApi::Client.fetch_token(@auth_code)
    redirect_to calculations_path
  end

  private

  def auth_code
    @auth_code = request.env.dig('rack.request.query_hash', 'code')
  end
end
