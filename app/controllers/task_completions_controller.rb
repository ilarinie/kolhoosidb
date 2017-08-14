class TaskCompletionsController < ApplicationController
  before_action :authenticate_user
  before_action :find_commune_and_check_if_user
  before_action :set_task

  def complete
    @task_completion = TaskCompletion.new(task_id: @task.id, user_id: current_user.id)
    if @task_completion.save
      render 'show', status: 200
    else
      @error = KolhoosiError.new('Error completing task', @task_completion.errors.full_messages)
      render 'error', status: 406
    end
  end


  def undo_last

  end

  def set_task
    @task = Task.find(params[:task_id])
    unless @commune.tasks.include? @task
      @error = KolhoosiError.new('Task id of another commune')
      render 'error',status: 406
      return false
    end
    true
  end


end
