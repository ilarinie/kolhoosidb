require 'rails_helper'


def authorize user
  token = Knock::AuthToken.new(payload: { sub: user.id }).token
  request.env['HTTP_AUTHORIZATION'] = "Bearer #{token}"
end

RSpec.describe RefundsController, type: :controller do
  Commune.public_activity_off
  render_views
  before(:each) do
    request.env['HTTP_ACCEPT'] = "application/json"
    request.env['HTTP_CONTENT_TYPE'] = '*/*, application/json'
  end

  describe 'POST /communes/:commune_id/refunds/' do
    before(:each) do
      @user = create(:user)
      @user2 = create(:user2)
      @commune = create(:commune, owner: @user)
      @commune2 = create(:commune2, owner: @user)
      @commune.users.append @user
      @commune.admins.append @user
      @commune.users.append @user2
    end
    it 'should be to create refunds and cancel/confirm them' do
      authorize(@user)
      post :create, params: { commune_id: @commune.id, refund: FactoryBot.attributes_for(:refund, to: @user2.id)}, format: :json
      expect(response).to have_http_status(200)
      expect(Refund.all.count).to eq(1)
      post :create, params: { commune_id: @commune.id, refund: FactoryBot.attributes_for(:refund, to: @user2.id)}, format: :json
      expect(response).to have_http_status(200)
      expect(Refund.all.count).to eq(2)
    end

    it 'should not be able to create refunds on another commune' do
      authorize(@user)
      post :create, params: { commune_id: @commune2.id, refund: FactoryBot.attributes_for(:refund, to: @user2.id)}, format: :json
      expect(response).to have_http_status(403)
      expect(Refund.all.count).to eq(0)
    end
  end

  describe 'POST /communes/:commune_id/refunds/confirm' do
    before(:each) do
      @user = create(:user)
      @user2 = create(:user2)
      @commune = create(:commune, owner: @user)
      @commune2 = create(:commune2, owner: @user)
      @commune.users.append @user
      @commune.admins.append @user
      @commune.users.append @user2
      @refund = Refund.create(from: @user.id, to: @user2.id, amount: 9.99)
    end
    it 'should be able to confirm a refund with a valid request' do
      authorize(@user2)
      post :reject, params: { commune_id: @commune.id, refund_id: @refund.id}, format: :json
      expect(response).to have_http_status(200)
      expect(Refund.all.count).to eq(0)
      expect(Purchase.all.count).to eq(0)
    end

    it 'should not be able to accept another users refund' do
      authorize(@user)
      post :confirm, params: { commune_id: @commune.id, refund_id: Refund.first.id }, format: :json
      expect(response).to have_http_status(403)
      expect(Refund.all.count).to eq(1)
      expect(Purchase.all.count).to eq(0)
    end
  end

  describe 'POST /communes/:commune_id/refunds/reject' do
    before(:each) do
      @user = create(:user)
      @user2 = create(:user2)
      @commune = create(:commune, owner: @user)
      @commune2 = create(:commune2, owner: @user)
      @commune.users.append @user
      @commune.admins.append @user
      @commune.users.append @user2
      @refund = Refund.create(from: @user.id, to: @user2.id, amount: 9.99)
    end
    it 'should be able to reject a refund with a valid request' do
      authorize(@user2)
      post :confirm, params: { commune_id: @commune.id, refund_id: @refund.id}, format: :json
      expect(response).to have_http_status(200)
      expect(Refund.all.count).to eq(0)
      expect(Purchase.all.count).to eq(2)
      expect(Purchase.first.amount.to_s).to eq("9.99")
      expect(Purchase.last.amount.to_s).to eq("-9.99")
    end
    it 'should not be able to reject another users refund' do
      authorize(@user)
      post :reject, params: { commune_id: @commune.id, refund_id: Refund.first.id }, format: :json
      expect(response).to have_http_status(403)
      expect(Refund.all.count).to eq(1)
      expect(Purchase.all.count).to eq(0)
    end
  end

  describe 'DELETE /communes/:commune_id/refunds/:refund_id/cancel' do
    before(:each) do
      @user = create(:user)
      @user2 = create(:user2)
      @commune = create(:commune, owner: @user)
      @commune2 = create(:commune2, owner: @user)
      @commune.users.append @user
      @commune.admins.append @user
      @commune.users.append @user2
      @refund = Refund.create(from: @user.id, to: @user2.id, amount: 9.99)
    end

    it 'should be able to cancel own refund' do
      authorize(@user)
      delete :cancel, params: { commune_id: @commune.id, refund_id: @refund.id }, format: :json
      expect(response).to have_http_status(200)
      expect(Refund.all.count).to eq(0)
    end

    it 'should not be able to cancel someone elses refund' do
      authorize(@user2)
      delete :cancel, params: { commune_id: @commune.id, refund_id: @refund.id }, format: :json
      expect(response).to have_http_status(403)
      expect(Refund.all.count).to eq(1)
    end
  end

end
