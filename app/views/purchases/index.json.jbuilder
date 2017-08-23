json.array! @purchases do |purchase|
  json.partial! 'purchases/purchase', purchase: purchase
end