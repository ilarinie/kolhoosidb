class UsersController < ApplicationController
  before_action :set_user, only: [:update, :show]
  before_action :authenticate_user, only: [:update, :show, :showCurrent, :change_password]


  def create
    # Luo uuden käyttäjän alhaalla olevien parametrien perusteella
    @user = User.new(user_params)
    if @user.save
      # Jos menee validaatiosta läpi ja tallentuu, palautetaan /views/users/create.json.jbuilder -näkymä ja koodi 201
      render "create", status: 201
    else
      # Jos validaatiot kusee, palautetaan errorit ja status 406
      render :json => { :errors =>  @user.errors.full_messages }, status: 406
    end
  end

  def update
    if @user == current_user
      if @user.update(user_update_params)
        render "show", status: 200
      else
        render :json => { :errors => @user.errors.full_messages}, status: 406
      end
    else
      render :json => { :errors => ["Cant update other profiles."]}, status: 406
    end
  end

  def change_password
    @user = current_user
    if @user.update(password: params[:password], password_confirmation: params[:password_confirmation])
      render json: { :message => "Password changed succesfully" }, status: 200
    else
      render json: { :errors => @user.errors.full_messages}, status: 406
    end
  end

  def show
  end

  def showCurrent
    @user = current_user
    render "show", status: 200
  end




  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_update_params
    params.require(:user).permit(:email, :name)
  end

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation, :name, :email)
  end

end
