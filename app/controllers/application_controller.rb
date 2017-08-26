class ApplicationController < ActionController::API
  include Knock::Authenticable
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  include PublicActivity::StoreController

  helper_method :find_commune_and_check_if_user
  helper_method :find_commune_and_check_if_admin

  def find_commune_and_check_if_user
    @commune = Commune.find(params[:commune_id])
    if @commune.users.include? current_user or @commune.is_admin current_user
      return @commune
    else
      @error = KolhoosiError.new('Only commune members can do that.')
      render 'error', status: 403
      return false
    end
  end

  def find_commune_and_check_if_admin
    @commune = Commune.find(params[:commune_id])
    if not @commune.is_admin current_user
      @error = KolhoosiError.new('Only admins can do that.')
      render 'error', status: 403
      return false
    else
      @commune
    end
  end


  # Tää renderöidään, kun autentikaatio tokenin kanssa feilaa
  def unauthorized_entity entity_name
    @error = KolhoosiError.new( 'Unauthorized request or invalid authorization header')
    render 'error', status: 401
  end

  # Tää renderöidään, kun pyydettyä tietoa ei ole kannassa
  def not_found
    @error = KolhoosiError.new('Record not found')
    render 'error', status: 404
  end

end
