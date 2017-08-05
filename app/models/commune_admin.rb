class CommuneAdmin < ApplicationRecord
  belongs_to :commune
  belongs_to :user
end
