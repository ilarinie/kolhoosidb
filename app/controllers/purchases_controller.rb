class PurchasesController < ApplicationController
  before_action :authenticate_user
  before_action :find_commune_and_check_if_user

  api :get, 'communes/:commune_id/purchases', 'Get purchases of a commune'
  def index
    @purchases = @commune.purchases
  end

  api :post, 'communes/:commune_id/purchases', 'Create a new purchase for a commune'
  def create
    @purchase = Purchase.new(purchase_params)
    @purchase.user = current_user
    if @purchase.save
      render 'show', status: 200
    else
      @error = KolhoosiError.new('Creating a purchase failed', @purchase.errors.full_messages )
      render 'error', status: 406
    end
  end

  api :delete, 'communes/:commune_id/purchases/:purchase_id', 'Cancel a purchase'
  def cancel
    render json: { message: 'Not implemented yet' }
  end

  api :get, 'communes/:commune_id/budget', 'Get communes budget'
  def budget

  end

  private

  def purchase_params
    params.require(:purchase).permit(:description, :amount, :purchase_category_id)
  end
end
