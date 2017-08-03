class UsersController < ApplicationController
  before_action :set_user, only: [:update, :show]
  before_action :authenticate_user, only: [:update, :show, :showCurrent, :change_password]

  def_param_group :user do
    param :user, Hash, :action_aware => true, :allow_nil => false, :required => true do
      param :username, String, "Unique username, 2-30 alphanumeric letters. Cannot be changed once set.", :required => true
      param :name, String, "Display name of the user, 2-30 alphanumeric letters. Can be changed.", :required => true
      param :email, String, "Email address of the user", :required => true
      param :password, String, :required => true
      param :password_confirmation, String, :required => true
    end
  end


  api :POST, "/users", "Create a new user."
  param_group :user, :as => :create
  example <<-EOS
  Response / Request
  {
    "user": {
      "id": "id of the user"
      "username": "Username of the user",
      "name": "Display name of the user",
      "email": "Email address of the user"
    }
  }
  EOS
  error :code => 406, :desc => "User model validation failed, message contains validation errors"
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

  api :PUT, "/users/:id", "Update an user. Only requests modifying the users own profile are allowed."
  param_group :user, :as => :update
  example <<-EOS
  Response / Request
  {
    "user": {
      "id": "id of the user"
      "username": "Username of the user",
      "name": "Display name of the user",
      "email": "Email address of the user"
    }
  }
  EOS
  error :code => 406, :desc => "User model validation failed, message contains validation errors"
  error :code => 401, :desc => "Unauthorized request"
  error :code => 404, :desc => "User not found"
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


  api :GET, "/users/:id", "Show a users profile."
  param :id,Integer, "ID of the user"
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
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation, :name, :email)
  end

end
