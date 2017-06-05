class Commune < ApplicationRecord
  has_many :users, through: :commune_users
  has_many :purchases
  has_many :tasks
end
