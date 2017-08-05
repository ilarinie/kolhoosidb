class UserTokenController < Knock::AuthTokenController
  before_action :authenticate
  rescue_from ActiveRecord::RecordNotFound, :with => :profile_not_found

  def create
    render :json => {:jwt => auth_token.token, :user => JSON.parse(@entity.to_json)}, status: :created
  end

  private
  # tää renderöidään kun yritetään autentikaatiota väärällä käyttäjänimellä/passulla
  def profile_not_found
    @error = KolhoosiError.new('Username or password wrong.')
    render 'application/error', status: 404
  end

end
