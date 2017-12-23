class RefundsController < ApplicationController
  before_action :find_commune_and_check_if_user


  api :post, '/communes/:commune_id/refunds'
  def create
    @refund = Refund.new(refund_params)
    @refund.from = current_user.id
    if @refund.save
      render json: { message: 'Refund created, wait for confirmation.'}, status: 200
    else
      @error = KolhoosiError.new('Creating a refund failed', @refund.errors.full_messages)
    end
  end

  api :post, '/communes/:commune_id/refunds/:refund_id/confirm'
  def confirm
    @refund = Refund.find(params[:refund_id])
    if @refund.to == current_user.id
      # Transaktio, kaiken pitää onnistua tai kaikki muutokset perutaan
      ActiveRecord::Base.transaction do
        @from = User.find(@refund.from)
        @to = User.find(@refund.to)
        @purchase = Purchase.new(commune_id: @commune.id, amount: @refund.amount, user_id: current_user.id, description: 'Refund from ' + @from.name + ' to ' + @to.name)
        @purchase2 = Purchase.new(commune_id: @commune.id, amount: (@refund.amount * -1), user_id: @from.id, description: 'Refund from ' + @from.name + ' to ' + @to.name)
        @purchase.save(:validate => false)
        @purchase2.save(:validate => false)
        @refund.destroy
        render json: { message: 'Refund accepted.'}, status: 200
      end
    else
      @error = KolhoosiError.new('Cant accept refund that is not yours to confirm.')
      render 'error', status: 403
    end
  end


  api :post, '/communes/:commune_id/refunds/:refund_id/reject'
  def reject
    @refund = Refund.find(params[:refund_id])
    if @refund.to == current_user.id
      @refund.destroy
      render json: { message: 'Refund rejected' }, status: 200
    else
      @error = KolhoosiError.new('Not your refund.')
      render 'error', status: 403
    end
  end

  private

  def refund_params
    params.require(:refund).permit(:to, :amount)
  end


end
