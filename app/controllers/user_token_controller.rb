class UserTokenController < Knock::AuthTokenController
  before_action :authenticate
  rescue_from ActiveRecord::RecordNotFound, :with => :profile_not_found

  def create
    @jwt = auth_token.token
    @user = @entity
    @sent_refunds = Refund.where(from: @user.id)
    @received_refunds = Refund.where(to: @user.id)
    render 'users/jwt', status: :created
  end

  private
  # tää renderöidään kun yritetään autentikaatiota väärällä käyttäjänimellä/passulla
  def profile_not_found
    @error = KolhoosiError.new('Username or password wrong.')
    render 'application/error', status: 404
  end

end
