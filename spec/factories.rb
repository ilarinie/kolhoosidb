FactoryGirl.define do

  factory :user, :class => User do
    username "test_user"
    password "test_password"
    password_confirmation "test_password"
    name "AapeliTestaaja"
  end

  factory :user2, :class => User do
    username "test_user_2"
    password "test_password"
    password_confirmation "test_password"
    name "AapoTestaaja"
  end

  factory :commune, :class => Commune do
    name "test_commune_1"
    description "test_commune_1"
  end

  factory :commune2, :class => Commune do
    name "test_commune_2"
    description "test_commune_2"
  end

end
