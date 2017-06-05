class CommuneUser < ApplicationRecord
has_many :users
  has_many :communes

end
