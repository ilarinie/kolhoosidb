class Invitation < ApplicationRecord
  belongs_to :commune
  belongs_to :user

  validates_uniqueness_of :user_id, scope: %i[commune_id]
end
