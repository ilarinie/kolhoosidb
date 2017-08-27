require 'csv'

PublicActivity.enabled = false

csv_users = File.read('/home/ile/old/migrated/users_migrated.csv')
csv = CSV.parse(csv_users, :headers => true)
csv.each do |row|
  u = User.new(row.to_hash)
  u.password = "passupassu"
  u.password_confirmation = "passupassu"
  u.save
end

c = Commune.create!(name: "The kommuuni", description: "The kommuuni", user_id: 1)

CommuneAdmin.create(user_id: 1, commune_id:1)
CommuneAdmin.create(user_id: 2, commune_id:1)
CommuneAdmin.create(user_id: 3, commune_id:1)
CommuneAdmin.create(user_id: 4, commune_id:1)

csv_users = File.read('/home/ile/old/migrated/purchase_categories.csv')
csv = CSV.parse(csv_users, :headers => true)
csv.each do |row|
  PurchaseCategory.create!(row.to_hash)
end

csv_users = File.read('/home/ile/old/migrated/purchases_migrated.csv')
csv = CSV.parse(csv_users, :headers => true)
csv.each do |row|
  p = Purchase.new(row.to_hash)
  p.save(validate: false)
end

csv_users = File.read('/home/ile/old/migrated/chores_migrated.csv')
csv = CSV.parse(csv_users, :headers => true)
csv.each do |row|
  Task.create(row.to_hash)
end

csv_users = File.read('/home/ile/old/migrated/task_completions_migrated.csv')
csv = CSV.parse(csv_users, :headers => true)
csv.each do |row|
  TaskCompletion.create(row.to_hash)
end

csv_users = File.read('/home/ile/old/migrated/xps_migrated.csv')
csv = CSV.parse(csv_users, :headers => true)
csv.each do |row|
  Xp.create(row.to_hash)
end

