json.array!(@communes) do |commune|
  json.id commune.id
  json.name commune.name
  json.description commune.description
  json.current_user_admin commune.is_admin @current_user
end