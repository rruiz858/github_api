class ApplicationController < ActionController::Base
  module Api
    module V1
      class BaseController < ApplicationController
        include JsonApiResponders
      end
    end
  end

  private

  def check_token
    redirect_to GithubApi::Client.auth_url unless GithubApi::Client.valid_token?
  end
end
