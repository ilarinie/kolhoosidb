class CommuneStatisticsController < ApplicationController
  before_action :authenticate_user
  before_action :find_commune_and_check_if_user

  def commune_statistics
    @total_purchases_count = @commune.purchases.count
    @total_purchases_sum = @commune.purchases.sum(:amount).to_s
    most = 0
    @completions = 0
    @commune.tasks.includes(:task_completions).each do |task|
      count = task.task_completions.count
      if  count > most
        @most = task
      end
      @completions = @completions + count
    end

  end

  def user_statistics

  end
end
