class PurchaseCategoriesController < ApplicationController
  before_action :authenticate_user
  before_action :find_commune_and_check_if_admin
  before_action :set_category, except: [:create]

  api :post, 'communes/:commune_id/purchase_categories'
  def create
    @category = PurchaseCategory.new(purchase_category_params)
    @category.commune = @commune
    if @category.save
      render json: { message: 'New category added'}, status: 200
    else
      @error = KolhoosiError.new('Creating a new category failed', @category.errors.full_messages)
      render 'error', status: 406
    end
  end

  api :put, 'communes/:commune_id/purchase_categories/:purchase_category_id'
  def update
    if @category.update(purchase_category_params)
      render json: { message: 'Category updated.' }, status: 200
    else
      @error = KolhoosiError.new('Updating the category failed', @category.errors.full_messages)
      render 'error', status: 406
    end
  end

  api :delete, 'commune/:commune_id/purchase_categories/:purchase_category_id'
  def destroy
    if @category.destroy
      render json: { message: 'Category deleted.'}, status: 200
    else
      @error = KolhoosiError.new('Deleting category failed', @category.errors.full_messages )
      render 'error', status: 406
    end

  end

  private

  def purchase_category_params
    params.require(:purchase_category).permit(:name)
  end

  def set_category
    @category = PurchaseCategory.find(params[:purchase_category_id])
  end
end
