require 'rails_helper'

RSpec.describe TopListController, type: :controller do
  before(:each) do
    generate_commune_and_users
  end
  describe 'GET index' do
    it 'should return valid response' do
      authorize(@user)
      get :index, params: {commune_id: @commune.id }, format: :json
      expect(response).to have_http_status(200)
    end
  end
end