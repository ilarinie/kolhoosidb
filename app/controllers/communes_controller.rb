class CommunesController < ApplicationController
  before_action :authenticate_user
  before_action :find_commune_and_check_if_user, only: [:show]
  before_action :find_commune_and_check_if_admin, only: [:update, :destroy]


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
    PublicActivity.enabled = false
    @commune = Commune.new(commune_params)
    @commune.owner = current_user
    @current_user = current_user
    if @commune.save
      PurchaseCategory.create(commune_id: @commune.id, name: "Default")
      @commune.admins.append current_user
      render "show", status: 201
    else
      @error = KolhoosiError.new('Commune creation failed due to invalid parameters', @commune.errors.full_messages )
      render "error", status: 406
    end
    PublicActivity.enabled = true
  end

  api :PUT, "/communes/:id", "Update a commune. Only commune admins are allowed to change commune details. Returns updated commune."
  param_group :commune, :as => :update
  param :id, Integer, "Id of the commune being updated."
  error :code => 406, :desc => "Param commune did not pass validations, returns error messages."
  def update
    @current_user = current_user
    if @commune.update(commune_params)
      render "show", status: 200
    else
      @error = KolhoosiError.new('Updating commune failed due to invalid parameters', @commune.errors.full_messages)
      render 'error', status: 406
    end
  end

  api :DELETE, "/communes/:id", "Delete a commune, all dependant tasks and budget. Only the owner of the commune can do this."
  def destroy
    if @commune.owner == current_user
      @commune.destroy!
      render :json => { :message =>  "Deleted." }, status: 200
    else
      @error = KolhoosiError.new('Only commune owners can delete communes.')
      render 'error', status: 401
    end
  end

  api :GET, '/communes', 'Get the current users communes'
  def index
    @current_user = current_user
    @communes = current_user.communes + current_user.admin_communes
  end

  def show
    @current_user = current_user
  end



  private

  def commune_params
    params.require(:commune).permit(:name, :description)
  end

end
