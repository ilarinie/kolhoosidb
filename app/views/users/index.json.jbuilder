json.array!(@users) do |user|
  json.partial! 'users/userindex', user: user
end