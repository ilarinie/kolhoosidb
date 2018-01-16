class PurchasesController < ApplicationController
  before_action :authenticate_user
  before_action :find_commune_and_check_if_user

  api :get, 'communes/:commune_id/purchases', 'Get purchases of a commune'
  def index
    @purchases = @commune.purchases.includes(:user).order('created_at DESC')
  end

  api :post, 'communes/:commune_id/purchases', 'Create a new purchase for a commune'
  def create
    @purchase = Purchase.new(purchase_params)
    @purchase.user = current_user
    @purchase.commune = @commune
    if @purchase.save
      TelegramApi.send_to_channel(@commune, '' + current_user.name + ' just bought ' + @purchase.description + '. Cost: ' + @purchase.amount.to_s + ' €. Category: ' + @purchase.purchase_category.name, false)
      render 'show', status: 200
    else
      @error = KolhoosiError.new('Creating a purchase failed', @purchase.errors.full_messages )
      render 'error', status: 406
    end
  end

  api :delete, 'communes/:commune_id/purchases/:purchase_id', 'Delete a purchase.'
  def cancel
    @purchase = Purchase.find(params[:purchase_id])
    if @purchase.user_id == current_user.id
      @purchase.destroy!
      render json: { message: 'Purchase deleted.'}, status: 204
    else
      @error = KolhoosiError.new('Can only delete your own purchases.')
      render 'error', status: 403
    end
  end

  api :post, 'communes/:commune_id/purchases/cancel_last', 'Cancel previous purchase'
  def cancel_last
    @purchase = Purchase.where(commune_id:params[:commune_id], user_id: current_user.id).last
    if @purchase.destroy!
      render json: { message: 'Purchase destroyed succesfully'}, status: 204
    else
      @error = KolhoosiError.new('Canceling purchase failed.')
      render 'error', status: 403
    end
  end

  api :get, 'communes/:commune_id/budget', 'Get communes budget'
  def budget
    @users = @commune.users + @commune.admins
    @total = @commune.purchases.sum(:amount)
    @avg = @total / @users.count
    render 'budget', status: 200
  end

  private

  def purchase_params
    params.require(:purchase).permit(:description, :amount, :purchase_category_id)
  end
end
