json.commune do
  json.name commune.name
  json.description commune.description
  json.created_at commune.created_at
  json.updated_at commune.updated_at
  json.tasks commune.tasks
  json.users commune.users
  json.purchases commune.purchases
  json.id commune.id
  json.current_user_admin admin
end
