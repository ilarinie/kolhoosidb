class CommunesController < ApplicationController
  def create
    @commune = Commune.new(commune_params)
    if @commune.save
      render plain: "OK"
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
