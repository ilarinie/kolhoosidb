json.commune do
  json.name commune.name
  json.description commune.description
  json.created_at commune.created_at
  json.updated_at commune.updated_at
  json.tasks commune.tasks
  json.users do
    json.array! commune.users do |user|
      json.name user.name
      json.id user.id
    end
  end
  json.admins do
    json.array! commune.admins do |admin|
      json.name admin.name
      json.id admin.id
    end
  end
  json.purchases commune.purchases
  json.id commune.id
  json.current_user_admin commune.is_admin @current_user
end
