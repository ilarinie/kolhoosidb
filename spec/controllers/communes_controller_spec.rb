require 'rails_helper'


def authorize user
  token = Knock::AuthToken.new(payload: { sub: user.id }).token
  request.env['HTTP_AUTHORIZATION'] = "Bearer #{token}"
end

RSpec.describe CommunesController, type: :controller do
  Commune.public_activity_off
  render_views
  before(:each) do
    request.env['HTTP_ACCEPT'] = "application/json"
    request.env['HTTP_CONTENT_TYPE'] = '*/*, application/json'
  end


  describe 'POST /communes' do
    before(:each) do
      @user = create(:user)
      authorize(@user)
    end

    it 'should create a new commune and give admin privs with valid request' do
      post :create, params: { commune: FactoryGirl.attributes_for(:commune)}, format: :json
      expect(response).to have_http_status(201)
      expect(Commune.all.count).to eq(1)
      expect(Commune.first.admins).to include(@user)
      result = JSON.parse(response.body)
      expect(result['name']).to eq('test_commune_1')
      expect(result['description']).to eq('test_commune_1')
    end
    it 'should not create a new commune without a name' do
      post :create, params: { commune: FactoryGirl.attributes_for(:commune, name: nil)}, format: :json
      expect(response).to have_http_status(406)
      expect(Commune.all.count).to eq(0)
    end
  end

  describe 'GET /communes' do
    before(:each) do
      @user = create(:user)
      @user2 = create(:user2)
      @commune = create(:commune, owner: @user)
      @commune2 = create(:commune2, owner: @user)
      @commune.users.append @user
      @commune2.admins.append @user
      @commune2.users.append @user2
      authorize(@user)
    end

    it 'should return users communes correctly' do
     get :index, format: :json
      expect(response).to have_http_status(200)
      expect(response.body).to include('test_commune_1')
      result = JSON.parse(response.body)
      expect(result.length).to eq(2)
    end

    it 'should return users own communes' do
      authorize(@user2)
      get :index, format: :json
      expect(response).to have_http_status(200)
      expect(response.body).to_not include('test_commune_1')
      result = JSON.parse(response.body)
      expect(result.length).to eq(1)
    end
  end

  describe 'PUT /communes/:id' do
    before(:each) do
      @user = create(:user)
      @user2 = create(:user2)
      @commune = create(:commune, owner: @user)
      @commune.admins.append @user
    end
    it 'should update commune with a valid request from an admin' do
      authorize(@user)
      put :update, format: :json, params: { commune_id: @commune.id, commune: FactoryGirl.attributes_for(:commune, name: 'ihan_eri') }
      expect(response.body).to include('ihan_eri')
      expect(response).to have_http_status(200)
    end

    it 'should not update commune with a valid request from an admin, if parameters are invalid' do
      authorize(@user)
      put :update, format: :json, params: { commune_id: @commune.id, commune: { name: '', description: ''}}
      expect(response).to have_http_status(406)
    end

    it 'should not update a commune without correct priviledges' do
      authorize(@user2)
      put :update, format: :json, params: { commune_id: @commune.id, commune: FactoryGirl.attributes_for(:commune, name: 'ihan_eri') }
      expect(response).to have_http_status(403)
    end
  end

  describe 'DELETE /communes/:id' do
    before(:each) do
      @user = create(:user)
      @user2 = create(:user2)
      @commune = create(:commune, owner: @user)
      @commune.admins.append @user
    end

    it 'should delete commune with a proper request from owner' do
      authorize(@user)
      delete :destroy, format: :json, params: { commune_id: @commune.id }
      expect(response).to have_http_status(200)
      expect(Commune.all.count).to eq(0)
    end

    it 'should not delete a commune with a request from non-owner' do
      authorize(@user2)
      delete :destroy, format: :json, params: { commune_id: @commune.id }
      expect(response).to have_http_status(403)
      expect(Commune.all.count).to eq(1)
    end

    it 'should return 406 when commune is not found' do
      authorize(@user)
      delete :destroy, format: :json, params: { commune_id: 23232323 }
      expect(response).to have_http_status(404)
      expect(Commune.all.count).to eq(1)
    end



  end
end
