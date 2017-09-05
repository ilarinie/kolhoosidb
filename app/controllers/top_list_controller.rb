class TopListController < ApplicationController
  before_action :authenticate_user
  before_action :find_commune_and_check_if_user

  api :get, '/communes/:commune_id/top_list'
  def index
    @weekly = Xp.where(commune_id: 1).where(created_at: DateTime.now.beginning_of_week..DateTime.now).group(:user).sum(:points).sort_by {|_key, value| value}.reverse.to_h
    @monthly = Xp.where(commune_id: 1).where(created_at: DateTime.now.beginning_of_month..DateTime.now).group(:user).sum(:points).sort_by {|_key, value| value}.reverse.to_h
    @day0 = Xp.where(commune_id: @commune.id).group(:user).sum(:points).sort_by {|_key, value| value}.reverse.to_h
    render 'xps/index'
  end

end
