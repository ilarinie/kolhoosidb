class TasksController < ApplicationController
  before_action :authenticate_user
  before_action :find_commune_and_check_if_user, only: [:index, :show]
  before_action :find_commune_and_check_if_admin, only: [:destroy, :update, :create]


  def_param_group :task do
    param :task, Hash,:action_aware => true do
      param :name, String, :desc => "Name of the task", :required => true
      param :priority, String, :desc => "How often should the task be done", :allow_nil => true
    end
  end


  api :get, 'communes/:commune_id/tasks'
  example <<-EOS
  Response
  [
    {
      "id": id of the task
      "name": Name of the task
      "priority": Priority of the task
      "completions": [
          {
            "name": Name of the person who completed
            "created_at": Date and time of completion    
          }
          ...
      ]
    }
    ...
  ]
  EOS
  def index
    @tasks = @commune.tasks
  end

  def show

  end

  api :post, 'communes/:commune_id/tasks/'
  param_group :task, :as => :create
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

  api :put, 'communes/:commune_id/tasks/:task_id'
  param_group :task, :as => :create
  def update
    @task = Task.find(params[:task_id])
    if @task.update(task_params)
      render 'show', status: 200
    else
      @error = KolhoosiError.new('Task could not be updated', @task.errors.full_messages)
      render 'error', status: 406
    end
  end


  api :delete, 'communes/:commune_id/tasks/:task_id'
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
    params.require(:task).permit(:name, :priority)
  end



end
