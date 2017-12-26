users = 2

(1..users).each do |i|
  User.create! name: "testaaja#{i}", username: "testaaja#{i}", email: "test@test.fi", password: "testaaja", password_confirmation: "testaaja"
end