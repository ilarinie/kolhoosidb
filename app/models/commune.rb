class Commune < ApplicationRecord
  has_many :commune_users, :dependent => :destroy
  has_many :users, through: :commune_users
  has_many :commune_admins, :dependent => :destroy
  has_many :admins, :through => :commune_admins, :source => :user
  has_many :purchases, :dependent => :destroy
  has_many :purchase_categories, :dependent => :destroy
  has_many :tasks, :dependent => :destroy
  belongs_to :owner, :class_name => 'User', :foreign_key => 'user_id'
  has_many :invitations

  validates :name, presence: true, length: {min:2, maximum: 30}
  validates :name, length: { maximum: 30 }


  def is_admin user
    return self.admins.include? user
  end

end
