require 'rails_helper'

RSpec.describe CommuneUsersController, type: :controller do
  Commune.public_activity_off
  render_views
  before(:each) do
    request.env['HTTP_ACCEPT'] = "application/json"
    request.env['HTTP_CONTENT_TYPE'] = '*/*, application/json'
  end
  describe 'POST /communes/:commune_id/invite' do
    before(:each) do
      generate_commune_and_users
    end
    it 'should generate an invite with a proper request' do
      authorize(@user)
      post :invite, params: { commune_id: @commune2.id, username: @user2.username }, format: :json
      expect(response).to have_http_status(200)
      expect(Invitation.all.count).to eq(1)
    end
    it 'should not generate an invite for user already in commune' do
      authorize(@user)
      post :invite, params: { commune_id: @commune.id, username: @user2.username }, format: :json
      expect(response).to have_http_status(406)
      expect(Invitation.all.count).to eq(0)
    end

  end

  describe 'POST /invitations/:invitation_id/accept' do
    before(:each) do
      generate_commune_and_users
      @invitation = create(:invitation, commune_id:@commune2.id, user_id:@user2.id)
    end
    it 'should be able to accept an invitation' do
      authorize(@user2)
      post :accept_invitation, params: { invitation_id:@invitation.id}, format: :json
      expect(response).to have_http_status(200)
      expect(Invitation.all.count).to eq(0)
      expect(Commune.find(@commune2.id).users.count).to eq(2)
    end
    it 'shouldnt be able to accept another users invitation' do
      authorize(@user)
      post :accept_invitation, params: { invitation_id:@invitation.id}, format: :json
      expect(response).to have_http_status(406)
      expect(Invitation.all.count).to eq(1)
      expect(Commune.find(@commune2.id).users.count).to eq(1)
    end
  end
  describe 'POST /invitations/:invitation_id/reject' do
    before(:each) do
      generate_commune_and_users
      @invitation = create(:invitation, commune_id:@commune2.id, user_id:@user2.id)
    end
    it 'should be able to reject an invitation' do
      authorize(@user2)
      post :reject_invitation, params: { invitation_id:@invitation.id}, format: :json
      expect(response).to have_http_status(200)
      expect(Invitation.all.count).to eq(0)
      expect(Commune.find(@commune2.id).users.count).to eq(1)
    end
    it 'shouldnt be able to accept another users invitation' do
      authorize(@user)
      post :reject_invitation, params: { invitation_id:@invitation.id}, format: :json
      expect(response).to have_http_status(406)
      expect(Invitation.all.count).to eq(1)
      expect(Commune.find(@commune2.id).users.count).to eq(1)
    end
  end

  describe 'DELETE /invitations/:invitation_id' do
    before(:each) do
      generate_commune_and_users
      @invitation = create(:invitation, commune_id:@commune2.id, user_id:@user2.id)
    end
    it 'should be able to cancel an invitation' do
      authorize(@user)
      post :cancel_invitation, params: { invitation_id:@invitation.id}, format: :json
      expect(response).to have_http_status(200)
      expect(Invitation.all.count).to eq(0)
      expect(Commune.find(@commune2.id).users.count).to eq(1)
    end
    it 'shouldnt be able to cancel another communes invitation' do
      authorize(@user2)
      post :cancel_invitation, params: { invitation_id:@invitation.id}, format: :json
      expect(response).to have_http_status(406)
      expect(Invitation.all.count).to eq(1)
      expect(Commune.find(@commune2.id).users.count).to eq(1)
    end
  end

  describe 'POST /communes/:commune_id/promote/:user_id' do
    before(:each) do
      generate_commune_and_users
    end
    it 'should be able to promote user with a valid request' do
      authorize(@user)
      post :promote_to_admin, params: { commune_id: @commune.id, user_id:@user.id }, format: :json
      expect(response).to have_http_status(200)
      expect(CommuneAdmin.all.count).to eq(3)
      expect(CommuneUser.all.count).to eq(2)
      expect(Commune.first.admins.count).to eq(2)
    end

    it 'should not be able to promote user if not owner' do
      @commune.admins.append(@user2)
      authorize(@user2)
      post :promote_to_admin, params: { commune_id: @commune.id, user_id:@user.id }, format: :json
      expect(response).to have_http_status(406)
      expect(CommuneAdmin.all.count).to eq(3)
      expect(CommuneUser.all.count).to eq(3)
      expect(Commune.first.admins.count).to eq(2)
    end

  end

  describe 'POST /communes/:commune_id/demote/:user_id' do
    before(:each) do
      generate_commune_and_users
    end
    it 'should be able to demote user with a valid request' do
      @commune.admins.append(@user2)
      authorize(@user)
      post :demote, params: { commune_id: @commune.id, user_id:@user2.id }, format: :json
      expect(response).to have_http_status(200)
      expect(CommuneAdmin.all.count).to eq(2)
      expect(CommuneUser.all.count).to eq(4)
      expect(Commune.first.admins.count).to eq(1)
    end

    it 'should not be able to demote user if not admin' do
      @commune.admins.append(@user2)
      authorize(@user2)
      post :demote, params: { commune_id: @commune.id, user_id:@user.id }, format: :json
      expect(response).to have_http_status(406)
      expect(CommuneAdmin.all.count).to eq(3)
      expect(CommuneUser.all.count).to eq(3)
      expect(Commune.first.admins.count).to eq(2)
    end

  end

  describe 'DELETE /communes/:commune_id/remove_user/:user_id' do
    before(:each) do
      generate_commune_and_users
    end
    it 'should be able to remove user with a valid request' do
      authorize(@user)
      expect(Commune.first.users.count).to eq(2)
      delete :remove_user, params: { commune_id:@commune.id, user_id:@user2.id }, format: :json
      expect(Commune.first.users.count).to eq(1)
    end
    it 'should not able to remove user with a invalid request' do
      authorize(@user2)
      expect(Commune.first.users.count).to eq(2)
      delete :remove_user, params: { commune_id:@commune.id, user_id:@user.id }, format: :json
      expect(response).to have_http_status(403)
      expect(Commune.first.users.count).to eq(2)
    end

  end

  describe 'DELETE /communes/:commune_id/leave' do
    before(:each) do
      generate_commune_and_users
    end

    it 'should be able to leave the commune with a valid request' do
      authorize(@user2)
      expect(Commune.first.users.count).to eq(2)
      delete :leave, params: { commune_id: @commune.id }, format: :json
      expect(response).to have_http_status(200)
      expect(Commune.first.users.count).to eq(1)
      expect(Commune.first.users).to_not include(@user2)
    end
    it 'should be able to leave the commune with a valid request while admin' do
      @commune.admins.append(@user2)
      CommuneUser.where(user_id: @user2.id).destroy_all
      authorize(@user2)
      expect(Commune.first.admins.count).to eq(2)
      delete :leave, params: { commune_id: @commune.id }, format: :json
      expect(response).to have_http_status(200)
      expect(Commune.first.admins.count).to eq(1)
      expect(Commune.first.admins).to_not include(@user2)
    end
    it 'should not be able to leave the commune if not member' do
      authorize(@user2)
      delete :leave, params: { commune_id: @commune2.id }, format: :json
      expect(response).to have_http_status(406)
    end
    it 'should destroy commune if last member' do
      authorize(@user)
      CommuneUser.where(user_id: @user.id).destroy_all
      delete :leave, params: { commune_id: @commune2.id }, format: :json
      expect(response).to have_http_status(200)
      expect(Commune.all.count).to eq(1)
    end
  end
end
