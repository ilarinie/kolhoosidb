class UserTokenController < Knock::AuthTokenController
  before_action :authenticate
  rescue_from ActiveRecord::RecordNotFound, :with => :profile_not_found

  def create
    @jwt = auth_token.token
    @user = @entity
    render 'users/jwt', status: :created
  end

  private
  # tää renderöidään kun yritetään autentikaatiota väärällä käyttäjänimellä/passulla
  def profile_not_found
    @error = KolhoosiError.new('Username or password wrong.')
    render 'application/error', status: 404
  end

end
