require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "POST /users/" do
    it "should create user with valid params" do
      @user = User.new(username: "testinger", name: "testinger", password: "passupassu", password_confirmation: "passupassu")
      request.env['HTTP_ACCEPT'] = "*/*, application/json"
      post :create, params: { user: FactoryGirl.attributes_for(:user) }, format: :json
      expect(User.all.count).to eq(1);
      expect(response).to have_http_status(201)
    end
    it "should not create user with invalid params" do
      @user = User.new(username: "testinger", name: "testinger", password: "123", password_confirmation: "12")
      post :create, params: { user: FactoryGirl.attributes_for(:user, password: "123", username: "a")}, format: :json
      expect(User.all.count).to eq(0);
      expect(response).to have_http_status(406)
    end
  end

end
