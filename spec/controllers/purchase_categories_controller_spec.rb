require 'rails_helper'
RSpec.describe PurchaseCategoriesController, type: :controller do
  before(:each) do
    generate_commune_and_users
  end
  describe 'POST /communes/:commune_id/purchase_categories' do
    it 'should create a purchase category with a valid request' do
      authorize(@user)
      post :create, params: { commune_id: @commune.id, purchase_category: FactoryBot.attributes_for(:purchase_category)}, format: :json
      expect(response).to have_http_status(200)
      expect(PurchaseCategory.all.count).to eq(2)
    end
    it 'should not a purchase category with a valid request' do
      authorize(@user)
      post :create, params: { commune_id: @commune.id, purchase_category: FactoryBot.attributes_for(:purchase_category, name: nil)}, format: :json
      expect(response).to have_http_status(406)
      expect(PurchaseCategory.all.count).to eq(1)
    end
  end
  describe 'PUT /communes/:commune_id/purchase_categories/:purchase_category_id' do
    it 'should update category with a valid request' do
      authorize(@user)
      put :update, params: {commune_id: @commune.id, purchase_category_id: @purchase_category.id, purchase_category: FactoryBot.attributes_for(:purchase_category, name: "asd")}, format: :json
      expect(response).to have_http_status(200)
      expect(PurchaseCategory.first.name).to eq("asd")
    end
    it 'should not update category with a invalid request' do
      authorize(@user)
      put :update, params: {commune_id: @commune.id, purchase_category_id: @purchase_category.id, purchase_category: FactoryBot.attributes_for(:purchase_category, name: nil)}, format: :json
      expect(response).to have_http_status(406)
      expect(PurchaseCategory.first.name).to eq("test_category")
    end
  end

  describe 'DELETE /communes/:commune_id/purchase_categories/:purchase_category_id' do
    it 'should remove category with a valid request' do
      authorize(@user)
      delete :destroy, params: { commune_id: @commune.id, purchase_category_id: @purchase_category.id }, format: :json
      expect(response).to have_http_status(200)
      expect(PurchaseCategory.all.count).to eq(0)
    end
  end

end