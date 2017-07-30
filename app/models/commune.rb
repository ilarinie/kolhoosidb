class Commune < ApplicationRecord
  has_many :commune_users, :dependent => :destroy
  has_many :users, through: :commune_users
  has_many :purchases, :dependent => :destroy
  has_many :tasks, :dependent => :destroy

  validates :name, presence: true, length: {min:2, maximum: 30}
  validates :name, length: { maximum: 30 }

  # Check if the user (given as a parameter) is an admin of the commune
  def is_admin user
    if cu = CommuneUser.find_by(user_id: user.id, commune_id: self.id)
      return cu.admin
    end
    false
  end

end
