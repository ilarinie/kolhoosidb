json.array!(@communes) do |commune|
  json.(commune, :id, :name)
end