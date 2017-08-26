communes = 2

1..communes do |i|
  commune = @commune.create(name: Faker::Team.unique.name,  description: 'Shit cunt')
  1..5 do |j|

  end


end