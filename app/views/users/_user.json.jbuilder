json.user do
  json.id user.id
  json.name user.name
  json.username user.username
  json.email user.email
  json.created_at user.created_at
  json.updated_at user.updated_at
  json.communes user.communes
  json.invitations do
    json.array! user.invitations do |invitation|
      json.id invitation.id
      json.commune_name invitation.commune.name
      json.commune_id invitation.commune.id
    end
  end
end
