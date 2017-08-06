class ApplicationController < ActionController::API
  include Knock::Authenticable
  rescue_from ActiveRecord::RecordNotFound, with: :not_found


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
