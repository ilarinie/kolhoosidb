require 'rails_helper'


def authorize user
  token = Knock::AuthToken.new(payload: { sub: user.id }).token
  request.env['HTTP_AUTHORIZATION'] = "Bearer #{token}"
end

RSpec.describe CommunesController, type: :controller do
  render_views
  before(:each) do
    request.env['HTTP_ACCEPT'] = "application/json"
    request.env['HTTP_CONTENT_TYPE'] = '*/*, application/json'
  end


  describe 'POST #create' do
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
      expect(result['commune']['name']).to eq('test_commune_1')
      expect(result['commune']['description']).to eq('test_commune_1')
    end
    it 'should not create a new commune without a name' do
      post :create, params: { commune: FactoryGirl.attributes_for(:commune, name: nil)}, format: :json
      expect(response).to have_http_status(406)
      expect(Commune.all.count).to eq(0)
    end
  end

  describe 'GET index' do
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

    it 'should reutnr users own communes' do
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
      put :update, format: :json, params: { id: @commune.id, commune: FactoryGirl.attributes_for(:commune, name: 'ihan_eri') }
      expect(response.body).to include('ihan_eri')
      expect(response).to have_http_status(200)
    end

  end
end
