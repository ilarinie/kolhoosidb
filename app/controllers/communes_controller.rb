class CommunesController < ApplicationController
  before_action :authenticate_user

  def create
    @commune = Commune.new(commune_params)
    if @commune.save
      render plain: "kakka"
    else
      render plain: "FAILED"
    end
  end

  def index
    @communes = Commune.all
  end


  private

  def commune_params
    params.permit(:name)
  end

end
