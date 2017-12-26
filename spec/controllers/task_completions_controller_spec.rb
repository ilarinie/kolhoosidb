require 'rails_helper'

RSpec.describe TaskCompletionsController, type: :controller do
  TaskCompletion.public_activity_off
  before(:each) do
    request.env['HTTP_ACCEPT'] = "*/*, application/json"
    generate_commune_and_users
    @task = create(:task, commune_id: @commune.id)
    @task2 = create(:task, commune_id: @commune2.id)
  end

  describe 'POST /communes/:commune_id/tasks/:task_id/complete' do
    it 'should be able to complete a task with valid request' do
      authorize(@user)
      post :complete, params: { commune_id: @commune.id, task_id: @task.id }, format: :json
      expect(response).to have_http_status(200)
      expect(TaskCompletion.all.count).to eq(1)
      @tc = TaskCompletion.first
      expect(@tc.user_id).to eq(@user.id)
      expect(@tc.task_id).to eq(@task.id)
      expect(Xp.all.count).to eq(1)
      expect(Xp.first.user_id).to eq(@user.id)
    end
    it 'should not be able to complete another communes task' do
      authorize(@user2)
      post :complete, params: { commune_id: @commune2.id, task_id: @task2.id }, format: :json
      expect(response).to have_http_status(403)
      expect(TaskCompletion.all.count).to eq(0)
      expect(Xp.all.count).to eq(0)
    end
    it 'should not be able to do anything with an improper request' do
      authorize(@user)
      post :complete, params: { commune_id: @commune2.id, task_id: @task.id }, format: :json
      expect(response).to have_http_status(406)
      expect(TaskCompletion.all.count).to eq(0)
      expect(Xp.all.count).to eq(0)
    end
  end

  describe 'DELETE /communes/:commune_id/task_completions/:task_completion_id' do
    before(:each) do
      @task_completion = create(:task_completion, task_id: @task.id, user_id: @user.id)
    end
    it 'should be able to remove completion with valid request' do
      authorize(@user)
      expect(TaskCompletion.all.count).to eq(1)
      delete :destroy, params: { commune_id: @commune.id, task_completion_id: @task_completion.id }, format: :json
      expect(response).to have_http_status(200)
      expect(TaskCompletion.all.count).to eq(0)
    end
    it 'should not be able to remove completion with invalid request' do
      authorize(@user2)
      expect(TaskCompletion.all.count).to eq(1)
      delete :destroy, params: { commune_id: @commune.id, task_completion_id: @task_completion.id }, format: :json
      expect(response).to have_http_status(406)
      expect(TaskCompletion.all.count).to eq(1)
    end
  end
end
