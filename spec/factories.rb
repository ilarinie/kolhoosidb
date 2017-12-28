FactoryBot.define do
  factory :commune_log do
    commune_id 1
    message "MyString"
  end
  factory :xp do
    points 1
    user_id 1
    task_id 1
  end
  factory :refund do
    to 1
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

  factory :task, :class => Task do
    name "test_task"
    priority 20
    reward 20
  end

  factory :task_completion, :class => TaskCompletion do

  end

  factory :purchase_category, :class => PurchaseCategory do
    name "test_category"
  end

  factory :purchase, :class => Purchase do
    amount "9.99"
    description "test purchase"
  end

  factory :purchase2, :class => Purchase do
    amount "2.22"
    description "test purchase 2"
  end

end
