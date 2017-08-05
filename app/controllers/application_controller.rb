class ApplicationController < ActionController::API
  include Knock::Authenticable

  # Tää renderöidään, kun autentikaatio tokenin kanssa feilaa
  def unauthorized_entity entity_name
    @error = KolhoosiError.new( 'Unauthorized request or invalid authorization header')
    render 'error', status: 401
  end


end
