 #json.commune do
  json.name commune.name
  json.description commune.description
  json.created_at commune.created_at
  json.updated_at commune.updated_at
  json.tasks []
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
  json.invitations do
    json.array! commune.invitations do |inv|
     json.commune_name inv.commune.name
     json.id inv.id
     json.commune_id inv.commune_id
     json.username inv.user.username
    end
  end 
  json.purchases []
  json.budget []
  json.feed []
  json.purchase_categories commune.purchase_categories
  json.id commune.id
  json.current_user_admin commune.is_admin @current_user
  json.is_owner commune.owner == @current_user
#end
