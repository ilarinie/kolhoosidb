FactoryGirl.define do

  factory :user, :class => User do
    username "test_user"
    password "test_password"
    password_confirmation "test_password"
    name "AapeliTestaaja"
  end

end
