require 'rails_helper'


def authorize user
  token = Knock::AuthToken.new(payload: { sub: user.id }).token
  request.env['HTTP_AUTHORIZATION'] = "Bearer #{token}"
end

RSpec.describe CommunesController, type: :controller do
  before(:each) do
    request.env['HTTP_ACCEPT'] = "*/*, application/json"
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
    end



  end

  describe 'GET index' do
    before(:each) do
      @user = create(:user)
      authorize(@user)
    end

    #it 'should return users communes correctly' do
    #  get :index
    #  expect(response).to have_http_status(200)
    #
    #end


  end
end
