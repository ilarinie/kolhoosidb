require 'rails_helper'

RSpec.describe PurchasesController, type: :controller do
  Purchase.public_activity_off
  before(:each) do
    request.env['HTTP_ACCEPT'] = "*/*, application/json"
  end

  describe 'GET /communes/:commune_id/purchases' do
    before(:each) do
      generate_commune_and_users
    end
    it 'should return a list of purchases' do
      authorize(@user)
      get :index, params: {commune_id: @commune.id}, format: :json
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /communes/:commune_id/budget' do
    before(:each) do
      generate_commune_and_users
    end
    it 'should return a list of purchases' do
      authorize(@user)
      get :budget, params: {commune_id: @commune.id}, format: :json
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /communes/:commune_id/purchases' do
    before(:each) do
      generate_commune_and_users
    end
    it 'should be able to create purchase with a valid request' do
      authorize(@user)
      post :create, params: { commune_id: @commune.id, purchase: FactoryBot.attributes_for(:purchase, purchase_category_id: @purchase_category.id) }, format: :json
      expect(response).to have_http_status(200)
      expect(Purchase.all.count).to eq(1)
    end
    it 'should not create purchase with an invalid request' do
      authorize(@user)
      post :create, params: { commune_id: @commune.id, purchase: FactoryBot.attributes_for(:purchase, amount: nil,  purchase_category_id: @purchase_category.id) }, format: :json
      expect(response).to have_http_status(406)
      expect(Purchase.all.count).to eq(0)
    end
  end

  describe 'DELETE /communes/:commune_id/purchases/:purchase_id' do
    before(:each) do
      generate_commune_and_users
      @purchase = create(:purchase, purchase_category_id: @purchase_category.id, user_id: @user.id, commune_id: @commune.id)
    end
    it 'should destroy a purchase with a valid request' do
      authorize(@user)
      expect(Purchase.all.count).to eq(1)
      delete :cancel, params: { commune_id: @commune.id, purchase_id:@purchase.id }, format: :json
      expect(response).to have_http_status(204)
      expect(Purchase.all.count).to eq(0)
    end
    it 'should not destroy anyone elses purchase' do
      authorize(@user2)
      expect(Purchase.all.count).to eq(1)
      delete :cancel, params: { commune_id: @commune.id, purchase_id:@purchase.id }, format: :json
      expect(response).to have_http_status(403)
      expect(Purchase.all.count).to eq(1)
    end
  end

  describe 'POST /communes/:commune_id/purchases/cancel_last' do
    before(:each) do
      generate_commune_and_users
      @purchase1 = create(:purchase, purchase_category_id: @purchase_category.id, user_id: @user.id, commune_id: @commune.id)
      @purchase2 = create(:purchase2, purchase_category_id: @purchase_category.id, user_id: @user.id, commune_id: @commune.id)
    end
    it 'should destroy latest purchase with a valid request' do
      expect(Purchase.all.count).to eq(2)
      authorize(@user)
      post :cancel_last, params: { commune_id: @commune.id }, format: :json
      expect(response).to have_http_status(204)
      expect(Purchase.all.count).to eq(1)
      expect(Purchase.first.amount.to_s).to eq("9.99")
      post :cancel_last, params: { commune_id: @commune.id }, format: :json
      expect(response).to have_http_status(204)
      expect(Purchase.all.count).to eq(0)
    end
  end
end
