class UserTokenController < Knock::AuthTokenController
  before_action :authenticate

  def create
    render :json => {:jwt => auth_token.token, :user => JSON.parse(@entity.to_json)}, status: :created
  end
end
