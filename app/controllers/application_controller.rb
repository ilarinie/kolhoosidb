class ApplicationController < ActionController::API
  def authentication
    render plain: "OK"
  end
end
