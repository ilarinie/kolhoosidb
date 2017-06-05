class User < ApplicationRecord
has_secure_password
  has_many :communes,through: :commune_users
  has_many :task_completions

end
