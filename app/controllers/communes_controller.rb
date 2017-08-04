class CommunesController < ApplicationController
  before_action :authenticate_user
  before_action :set_commune_and_check_if_permitted_user, only: [:show]
  before_action :set_commune_and_check_if_admin, only: [:update, :destroy]

  def_param_group :commune do
    param :commune, Hash,:action_aware => true do
      param :name, String, :desc => "Name of the commune", :required => true
      param :description, String, :desc => "Short description of the commune", :allow_nil => true
    end
  end

  api :POST, "/communes",  "Create a new commune, current user becomes and admin and member of the commune. Returns new commune."
  param_group :commune, :as => :create
  example <<-EOS
  {
    "commune": {
      "name": Name of the commune,
      "description": Short description of the commune,    
    }
  }
  EOS
  def create
    @commune = Commune.new(commune_params)
    @commune.owner = current_user
    if @commune.save
      if CommuneUser.create(user_id: current_user.id, commune_id: @commune.id, admin: true )
        render "show", status: 201
      else
        render plain: "Failed to add new user to commune", status: 500
      end
    else
      render :json => { :errors => @commune.errors.full_messages}, status: 406
    end
  end

  api :PUT, "/communes/:id", "Update a commune. Only commune admins are allowed to change commune details. Returns updated commune."
  param_group :commune, :as => :update
  param :id, Integer, "Id of the commune being updated."
  error :code => 406, :desc => "Param commune did not pass validations, returns error messages."
  def update
    if @commune.update(commune_params)
      render "show", status: 200
    else
      render :json => { :errors => @commune.errors.full_messages }, status: 406
    end
  end

  api :DELETE, "/communes/:id", "Delete a commune, all dependant tasks and budget. Only the owner of the commune can do this."
  def destroy
    if @commune.owner == current_user
      if @commune.destroy
        render plain: "Deleted.", status: 204
      else
        render plain: "Commune could not be deleted.", status: 406
      end
    else
      render plain: "Only commune owners can delete communes.", status: 401
    end
  end

  def index
    @communes = current_user.communes
  end

  def show
  end



  private

  def commune_params
    params.require(:commune).permit(:name, :description)
  end

  def set_commune_and_check_if_permitted_user
    @commune = Commune.find(params[:id])
    unless @commune.users.include? current_user
      render :json => { :errors => "User not a part of the commune." }, status: 406
      return false
    end
    true
  end

  def set_commune_and_check_if_admin
    @commune = Commune.find(params[:id])
    @admin = @commune.is_admin current_user
    unless @admin
      render :json => { :errors => "User not a admin of the commune." }, status: 406
      return false
    end
    true
  end

end
