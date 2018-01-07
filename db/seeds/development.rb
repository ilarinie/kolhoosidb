users = 3



(1..users).each do |i|
  User.create! name: "testaaja#{i}", username: "testaaja#{i}", email: "test@test.fi", password: "testaaja", password_confirmation: "testaaja"
end

@commune = Commune.create!(owner: User.first, name: 'Test commune', description: 'test description')

@commune.admins << User.first
@commune.users << User.second
@commune.users << User.last

PurchaseCategory.create!(commune_id: Commune.first.id, name: 'Default')