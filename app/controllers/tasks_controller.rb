class TasksController < ApplicationController
  before_action :authenticate_user
  before_action :find_commune_and_check_if_user, only: [:index, :show]
  before_action :find_commune_and_check_if_admin, only: [:destroy, :update, :create]


  def index
    @tasks = @commune.tasks
  end

  def show

  end

  def create
    @task = Task.new(task_params)
    @task.commune = @commune
    if @task.save
      render 'show', status: 201
    else
      @error = KolhoosiError.new('Creating a new task failed', @task.errors.full_messages)
      render 'error', status: 406
    end
  end

  def update
    @task = Task.find(params[:task_id])
    if @task.update(task_params)
      render 'show', status: 200
    else
      @error = KolhoosiError.new('Task could not be updated', @task.errors.full_messages)
      render 'error', status: 406
    end
  end

  def destroy
    @task = Task.find(params[:task_id])
    if @task.destroy
      render json: { message: 'Task deleted succesfully' }, status: 200
    else
      @error = KolhoosiError.new('Task could not be deleted.', @task.errors.full_messages)
      render 'error', status: 406
    end
  end



  private

  def task_params
    params.require(:task).permit(:name, :priority, :points)
  end



end
