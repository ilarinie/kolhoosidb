json.weekly do
  json.array! @weekly do |item|
    json.partial! 'xps/xp', item: item

  end
end
json.monthly do
  json.array! @monthly do |item|
    json.partial! 'xps/xp', item: item
  end
end
json.from_beginning do
  json.array! @day0 do |item|
    json.partial! 'xps/xp', item: item

  end
end