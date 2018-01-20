json.array!(@communes) do |commune|
  json.id commune.id
  json.name commune.name
  json.description commune.description
  json.current_user_admin commune.is_admin @current_user
  json.is_owner commune.owner == @current_user
  json.members commune.users + commune.admins
end
