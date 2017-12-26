class UsersController < ApplicationController
  before_action :set_user, only: [:update, :show]
  before_action :authenticate_user, only: [:update, :show, :showCurrent, :change_password, :index]
  before_action :find_commune_and_check_if_user, only: [:index]

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
      @sent_refunds = []
      @received_refunds = []
      render "create", status: 201
    else
      @error = KolhoosiError.new('Creating user failed due to invalid parameters', @user.errors.full_messages)
      # Jos validaatiot kusee, palautetaan errorit ja status 406
      render "error", status: 406
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
        @sent_refunds = Refund.where(from: @user.id)
        @received_refunds = Refund.where(to: @user.id)
        render "show", status: 200
      else
        @error = KolhoosiError.new('Updating user failed due to invalid parameters', @user.errors.full_messages)
        render "error", status: 406
      end
    else
       @error = KolhoosiError.new('Cant update other profiles', [])
        render "error", status: 406
    end
  end

  api :GET, "communes/:commune_id/users/", "Index all users."
  example <<-EOS
  Response / Request
  {
    "user": {
      "id": 2,
      "username": "Testimies666"
    }
  }
  EOS
  def index
    @users = @commune.users
    @admins = @commune.admins
  end

  api :GET, "/users/:id", "Show a users profile."
  param :id,Integer, "ID of the user"
  def show
  end

  api :POST, '/users/change_password', 'Change your (current users) password'
  param :password, String
  param :password_confirmation, String
  def change_password
    @user = current_user
    if @user.update(password: params[:password], password_confirmation: params[:password_confirmation])
      render 'show', status: 200
    else
      @error = KolhoosiError.new('Updating password failed', @user.errors.full_messages)
      render 'error', status: 406
    end
  end


  def show_current
    @user = current_user
    @sent_refunds = Refund.where(from: @user.id)
    @received_refunds = Refund.where(to: @user.id)
    render "show", status: 200
  end




  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_update_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation, :default_commune_id, :default_theme)
  end

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation, :name, :email)
  end

end
