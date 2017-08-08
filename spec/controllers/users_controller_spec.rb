require 'rails_helper'


def authorize user
    token = Knock::AuthToken.new(payload: { sub: user.id }).token
    request.env['HTTP_AUTHORIZATION'] = "Bearer #{token}"
end

RSpec.describe UsersController, type: :controller do
  before(:each) do
    request.env['HTTP_ACCEPT'] = "*/*, application/json"
  end

  describe "POST /users/" do
    it "should create user with valid params" do
      post :create, params: { user: FactoryGirl.attributes_for(:user) }, format: :json
      expect(User.all.count).to eq(1);
      expect(response).to have_http_status(201)
    end
    it "should not create user with invalid params" do
      post :create, params: { user: FactoryGirl.attributes_for(:user, password: "123", username: "a")}, format: :json
      expect(User.all.count).to eq(0);
      expect(response).to have_http_status(406)
    end
  end
  describe "GET /users/" do
    render_views
    before(:each) do
      @user = create(:user)
      @user2 = create(:user2)
      authorize(@user)
    end
    it "should get all users" do
      get :index, format: :json
      expect(response).to have_http_status(200)
      expect(response.body).to include("test_user_2")
    end
  end
  describe "PUT /users/:id" do
    before(:each) do
      @user = create(:user)
      authorize(@user)
    end
    it "should update user name with valid request" do
      patch :update, params: {id: @user.id,  user: FactoryGirl.attributes_for(:user, name: "Kalapää")}, format: :json
      expect(response).to have_http_status(200)
      expect(User.find(@user.id).name).to eq("Kalapää")
    end
    it "should not update user to have an empty name" do
      patch :update, params: {id: @user.id,  user: FactoryGirl.attributes_for(:user, name: "")}, format: :json
      expect(User.find(@user.id).name).to eq(build(:user).name)
    end
    it "should not update user to have a too long name" do
      patch :update, params: {id: @user.id,  user: FactoryGirl.attributes_for(:user, name: "12345678901234567890123543645756835345234234")}, format: :json
      expect(User.find(@user.id).name).to eq(build(:user).name)
    end
    it "should not update user to have a too short name" do
      patch :update, params: {id: @user.id,  user: FactoryGirl.attributes_for(:user, name: "a")}, format: :json
      expect(User.find(@user.id).name).to eq(build(:user).name)
    end
    it "should not update username" do
      patch :update, params: {id: @user.id,  user: FactoryGirl.attributes_for(:user, username: "newUsername")}, format: :json
      expect(User.find(@user.id).username).to eq(build(:user).username)
    end
    it "should update password on a valid request" do
      patch :update, params: {id: @user.id,  user: FactoryGirl.attributes_for(:user, password: "goodPassword", password_confirmation: "goodPassword")}, format: :json
      user = User.find(@user.id)
      expect(user.authenticate("goodPassword")).to_not eq(false)
    end
    it "should not update password if requirements are not met" do
      patch :update, params: {id: @user.id,  user: FactoryGirl.attributes_for(:user, password: "kala")}, format: :json
      user = User.find(@user.id)
      expect(user.authenticate("kala")).to eq(false)
    end
    it "should not update password without confirmation" do
      patch :update, params: {id: @user.id,  user: FactoryGirl.attributes_for(:user, password: "goodPassword")}, format: :json
      user = User.find(@user.id)
      expect(user.authenticate("goodPassword")).to eq(false)
    end
    it "should not update password with wrong confirmation" do
      patch :update, params: {id: @user.id,  user: FactoryGirl.attributes_for(:user, password: "goodPassword", password_confirmation:"wrongPassword")}, format: :json
      user = User.find(@user.id)
      expect(user.authenticate("goodPassword")).to eq(false)
    end
  end

end
