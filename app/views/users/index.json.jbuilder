json.users do
  json.array!(@users) do |user|
    json.id user.id
    json.name user.name
  end
end
json.admins do
  json.array!(@admins) do |admin|
    json.id admin.id
    json.name admin.name
  end
end

