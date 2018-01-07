json.id purchase.id
json.name purchase.user.name
json.amount purchase.amount
json.created_at purchase.created_at
json.description purchase.description
json.user_id purchase.user.id
if purchase.purchase_category_id.nil?
  json.category "Refund"
else
  json.category purchase.purchase_category.name
end

