class TaskCompletionsController < ApplicationController
  before_action :authenticate_user
  before_action :find_commune_and_check_if_user
  before_action :set_task, except: [:destroy, :undo_last]

  api :post, 'communes/:commune_id/tasks/:task_id/complete'
  example <<-EOS
  Response
  {
    "name": "Completers' display name",
    "created_at": "Date and time of completion"
  }
  EOS
  def complete
    @task_completion = TaskCompletion.new(task_id: @task.id, user_id: current_user.id)
    if @task_completion.save
      TelegramApi.send_to_channel(@commune, @task_completion.to_message, true)
      Xp.create!(commune_id: @commune.id, user_id: current_user.id, points: @task.reward ||= 0, task_id: @task.id)
      render 'show', status: 200
    else
      @error = KolhoosiError.new('Error completing task', @task_completion.errors.full_messages)
      render 'error', status: 406
    end
  end

  api :delete, 'communes/:commune_id/task_completions/:task_completion_id'
  def destroy
    @task_completion = TaskCompletion.find(params[:task_completion_id])
    if @task_completion.user == current_user or @commune.admins.include? current_user
      @xp = Xp.where(user_id: @task_completion.user_id, task_id: @task_completion.task_id).last
      unless @xp.nil?
        @xp.destroy!
      end
      @task_completion.destroy!
      render json: { message: "Deleted." }, status: 200
    else
      @error = KolhoosiError.new('You cant delete other peoples completions unless admin.')
      render 'error', status: 406
    end
  end


  api :delete, 'communes/:commune_id/undo_last_completion'
  def undo_last
    @task_completion = TaskCompletion.where(user_id: current_user.id).last!
    id = @task_completion.id
    task_id = @task_completion.task_id
    @task_completion.destroy!
    @xp = Xp.where(user_id: @task_completion.user_id, task_id: @task_completion.task_id).last
    unless @xp.nil?
      @xp.destroy!
    end
    TelegramApi.send_to_channel(@commune, "#{current_user.name} canceled completing #{@task_completion.task.name}.", true)
    render json: { id: id, task_id: task_id }, status: 200
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
