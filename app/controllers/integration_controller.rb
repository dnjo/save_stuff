class IntegrationController < ApplicationController
  before_action :require_login

  def new_reddit
    reddit_integration = RedditIntegration.new_from_callback_code(params[:code])
    integration = Integration.create(listable: reddit_integration, user: current_user)
    render json: {
      integration_id: integration.id
    }
  end
end
