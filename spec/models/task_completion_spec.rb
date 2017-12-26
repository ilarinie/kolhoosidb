require 'rails_helper'

RSpec.describe TaskCompletion, type: :model do
  before(:each) do
    generate_commune_and_users
  end
  describe 'to_message does not return error' do
    it 'should be fine' do
      @task = create(:task, commune_id: @commune.id)
      @tc = create(:task_completion, task_id: @task.id, user_id: @user.id)
      expect(@tc.to_message).to eq(@user.name + " just completed " + @task.name + ".")
    end
    it 'should be fine too' do
      @task = create(:task, commune_id: @commune.id, completion_text: "teki jotakin.")
      @tc = create(:task_completion, task_id: @task.id, user_id: @user.id)
      expect(@tc.to_message).to eq(@user.name + " teki jotakin.")
    end
  end
end