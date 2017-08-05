json.array!(@communes) do |commune|
  json.partial! 'communes/commune', commune: commune
      end