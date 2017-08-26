FactoryGirl.define do
  factory :refund do
    to 1
    from 1
    amount "9.99"
  end
  factory :invitation do
    user_id 1
    commune_id 1
  end

  factory :user, aliases: [:owner, :admin], :class => User do
    username "test_user"
    password "test_password"
    password_confirmation "test_password"
    email "test_email@email.com"
    name "AapeliTestaaja"
  end

  factory :user2, :class => User do
    username "test_user_2"
    password "test_password"
    password_confirmation "test_password"
    email "test_email@email.com"
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
