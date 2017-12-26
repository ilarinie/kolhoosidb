require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  render_views
  Commune.public_activity_off
  Task.public_activity_off

  before(:each) do
    request.env['HTTP_ACCEPT'] = "application/json"
    request.env['HTTP_CONTENT_TYPE'] = '*/*, application/json'
  end

  describe 'GET /communes/:commune_id/tasks' do
    before(:each) do
      generate_commune_and_users
    end
    it 'should return a task list with valid request' do
      authorize(@user)
      get :index, params: { commune_id:@commune.id }, format: :json
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /communes/:commune_id/tasks' do
    before(:each) do
      generate_commune_and_users
    end
    it 'should create a task with a valid request' do
      authorize(@user)
      post :create, params: { commune_id: @commune.id, task: FactoryBot.attributes_for(:task) }, format: :json
      expect(response).to have_http_status(201)
      expect(Task.all.count).to eq(1)
      expect(Task.first.name).to eq("test_task")
      expect(Task.first.priority).to eq(20)
      expect(Task.first.reward).to eq(20)
    end
    it 'should not create a task with invalid request' do
      authorize(@user)
      post :create, params: { commune_id: @commune.id, task: FactoryBot.attributes_for(:task, name: nil) }, format: :json
      expect(response).to have_http_status(406)
      expect(Task.all.count).to eq(0)
    end
  end

  describe 'PUT /communes/:commune_id/tasks/:task_id' do
    before(:each) do
      generate_commune_and_users
      @task = create(:task, commune_id: @commune.id)
    end
    it 'should update a task with a valid request' do
      authorize(@user)
      put :update, params: { commune_id: @commune.id, task_id: @task.id, task: FactoryBot.attributes_for(:task, name: "changed", reward: 999, priority: 999 )}, format: :json
      expect(response).to have_http_status(200)
      task = Task.first
      expect(task.name).to eq("changed")
      expect(task.priority).to eq(999)
      expect(task.reward).to eq(999)
    end
    it 'should not update a task with an invalid request' do
      authorize(@user)
      put :update, params: { commune_id: @commune.id, task_id: @task.id, task: FactoryBot.attributes_for(:task, name: nil, reward: 999, priority: 999 )}, format: :json
      expect(response).to have_http_status(406)
      task = Task.first
      expect(task.name).to eq("test_task")
      expect(task.priority).to eq(20)
      expect(task.reward).to eq(20)
    end
  end
  describe 'DELETE /communes/:commune_id/tasks/:task_id' do
    before(:each) do
      generate_commune_and_users
      @task = create(:task, commune_id: @commune.id)
    end

    it 'should destroy a task with a proper request' do
      authorize(@user)
      delete :destroy, params: { commune_id: @commune.id, task_id:@task.id }, format: :json
      expect(response).to have_http_status(200)
      expect(Task.all.count).to eq(0)
    end

    it 'should not delete a task without admin priviledges' do
      authorize(@user2)
      delete :destroy, params: { commune_id: @commune.id, task_id:@task.id }, format: :json
      expect(response).to have_http_status(403)
      expect(Task.all.count).to eq(1)
    end
  end

end