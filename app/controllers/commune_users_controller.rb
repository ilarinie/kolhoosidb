class CommuneUsersController < ApplicationController
  before_action :authenticate_user
  before_action :find_commune_and_check_if_admin, only: [:invite, :promote_to_admin,:demote, :remove_user]

  api :post, 'communes/:commune_id/invite/', 'Invite user specified by id'
  def invite
    @user = User.find_by(username: params[:username])
    if @commune.users.include? @user
      @error = KolhoosiError.new('Allready a user')
      render 'error', status: 406
      return
    end
    @invitation = Invitation.new(user_id: @user.id , commune_id: @commune.id)
    if @invitation.save
      render json: { message: 'Invitation sent to ' + @user.name}, status: 200
    else
      @error = KolhoosiError.new('Invitation failed, try again', @invitation.errors.full_messages )
      render 'error', status: 406
    end
  end

  api :post, 'invitations/:invitation_id/accept', 'Accepts invitation specified by id'
  def accept_invitation
    @invitation = Invitation.find(params[:invitation_id])
    if @invitation.user_id == current_user.id
      CommuneUser.create(user_id: current_user.id, commune_id: @invitation.commune_id)
      @invitation.destroy
      render json: { message: 'Invitation accepted succesfully.'}, status: 200
    else
      @error = KolhoosiError.new('What are you trying to do?')
      render 'error', status: 406
    end
  end

  api :post, 'invitations/:invitation_id/reject', 'Rejects invitation by id'
  def reject_invitation
    @invitation = Invitation.find(params[:invitation_id])
    if @invitation.user_id == current_user.id
      @invitation.destroy
      render json: { message: 'Invitation rejected.'}, status: 200
    else
      @error = KolhoosiError.new('What are you trying to do?')
      render 'error', status: 406
    end
  end


  api :delete, 'invitations/:invitation_id', 'Cancels the invitation by id'
  def cancel_invitation
    @invitation = Invitation.find(params[:invitation_id])
    @commune = Commune.find(@invitation.commune_id)
    if @commune.admins.include? current_user
      @invitation.destroy
      render json: { message: 'Invitation cancelled.' }, status: 200
    else
      @error = KolhoosiError.new('You cant do that.')
      render 'error', status: 406
    end
  end

  api :post, 'communes/:commune_id/promote/:user_id', 'Promotes the user to admin'
  def promote_to_admin
    @user = User.find(params[:user_id])
    if @commune.owner == current_user
      CommuneAdmin.create(user_id: @user.id, commune_id: @commune.id)
      CommuneUser.find_by(user_id: @user.id, commune_id: @commune.id).first.destroy
      render json: { message: 'User promoted succesfully' }, status: 200
    else
      @error = KolhoosiError.new('Only owners can do that.')
      render 'error', status: 406
    end
  end

  api :post, 'communes/:commune_id/demote/:user_id', 'Demotes the user to normal'
  def demote
    @user = User.find(params[:user_id])
    if @commune.owner == current_user
      CommuneUser.create(user_id: @user.id, commune_id: @commune.id)
      CommuneAdmin.find_by(user_id: @user.id, commune_id: @commune.id ).first.destroy
      render json: { message: 'User demoted succesfully'}, status: 200
    else
      @error = KolhoosiError.new('You cant do that.')
      render 'error', status: 406
    end
  end

  api :delete, 'communes/:commune_id/remove_user/:user_id', 'Removes the user from the commune'
  def remove_user
    @user = User.find(params[:user_id])
    CommuneUser.find_by(user_id: @user.id, commune_id: @commune.id).first.delete
    render json: { message: 'User removed from the commune.' }
  end

end
