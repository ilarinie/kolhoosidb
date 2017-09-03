class ActivityController < ApplicationController
  before_action :authenticate_user
  before_action :find_commune_and_check_if_user

  def index
    @activities = PublicActivity::Activity.where(recipient: @commune).order('created_at DESC').limit(10)
  end


end
