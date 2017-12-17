require 'rails_helper'

RSpec.describe "Create user, commune, add user", type: :request do

  it 'should create a new user, commune and add another user' do
    @user2 = create(:user2)
    headers = {
        "ACCEPT" => "application/json"
    }

    post '/users/', params: { user: FactoryBot.attributes_for(:user) }, :headers => headers

    @user = User.find_by(username: 'test_user')

    expect(response).to have_http_status(201)

    post '/usertoken', params: { auth: { username: @user.username, password: 'test_password'}}, :headers => headers

    expect(response).to have_http_status(201)

    json = JSON.parse(response.body)

    headers = {
        "ACCEPT" => "application/json",
        "Authorization" => "Bearer " + json["jwt"]
    }

    post '/communes', params: { commune: FactoryBot.attributes_for(:commune)}, :headers => headers

    expect(response).to have_http_status(201)

    @commune = Commune.first


    post "/communes/#{@commune.id}/invite", params: { username: @user2.username }, :headers => headers

    expect(response).to have_http_status(200)


    headers ={
        "ACCEPT" => "application/json"
    }
    post '/usertoken', params: { auth: { username: @user2.username, password: @user2.password }}, :headers => headers

    expect(response).to have_http_status(201)

    json = JSON.parse(response.body)
    headers = {
        "ACCEPT" => "application/json",
        "Authorization" => "Bearer " + json["jwt"]
    }

    json = JSON.parse(response.body)

    invitation =  json["user"]["invitations"]

    id = invitation[0]["id"]

    post "/invitations/#{id}/accept", :headers => headers

    expect(response).to have_http_status(200)

    expect(CommuneUser.all.count).to eq(1)
    expect(Invitation.all.count).to eq(0)

    get "/communes", :headers => headers



  end
end