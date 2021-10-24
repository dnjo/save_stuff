class ItemController < ApplicationController
  before_action :require_login

  def list
    render json: current_user.items
  end
end
