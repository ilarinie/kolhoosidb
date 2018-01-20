json.commune_total @total
json.commune_avg @avg
json.users do |user|
  json.array! @users do |p|
    json.name p.name
    json.total p.purchases.where(commune_id: @commune.id).sum(:amount)
  end
end
