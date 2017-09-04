json.id task.id
json.name task.name
json.priority task.priority
json.completions do
  json.array! task.get_last_completions do |completion|
    json.name completion.user.name
    json.created_at completion.created_at
  end
end