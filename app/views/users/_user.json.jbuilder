json.user do
  json.id user.id
  json.name user.name
  json.username user.username
  json.email user.email
  json.created_at user.created_at
  json.updated_at user.updated_at
  json.communes user.communes
end
