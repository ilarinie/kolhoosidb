class CommuneUser < ApplicationRecord
  belongs_to :user
  belongs_to :commune

end
