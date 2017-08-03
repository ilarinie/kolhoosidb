require 'rails_helper'

RSpec.describe "Auth", type: :request do
  describe "POST /user_token" do
    it "should return a jwt token on a valid login" do
      user = create(:user)
      params = { auth: { username: user.username, password: user.password }}
      post "/usertoken", params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      expect(response).to have_http_status(:created)
    end
    it "should return unauthorized on an invalid login" do
      create(:user)
      params = { auth: { username: "wrong", password: "wrong" }}
      post "/usertoken", params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      expect(response).to have_http_status(:not_found)
    end
  end
end
