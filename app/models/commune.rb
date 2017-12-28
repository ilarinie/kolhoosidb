class Commune < ApplicationRecord
  #include PublicActivity::Model
  #tracked owner: Proc.new{ |controller, model| controller.current_user}, recipient: Proc.new{ |controller, model| controller.find_commune_and_check_if_admin }

  attr_accessor :commune

  has_many :commune_users, :dependent => :destroy
  has_many :users, through: :commune_users
  has_many :commune_admins, :dependent => :destroy
  has_many :admins, :through => :commune_admins, :source => :user
  has_many :purchases, :dependent => :destroy
  has_many :purchase_categories, :dependent => :destroy
  has_many :tasks, :dependent => :destroy
  belongs_to :owner, :class_name => 'User', :foreign_key => 'user_id'
  has_many :invitations
  has_many :xps

  validates :name, presence: true, length: {min:2, maximum: 30}
  validates :name, length: { maximum: 30 }

  after_create :log_create
  after_update :log_update

  self.primary_key = 'id'

  def is_admin user
    return self.admins.include? user
  end

  def log_create
    message = "#{self.owner.name} created #{self.name}!"
    CommuneLog.create(commune_id: self.id, message: message, long_message: "")
  end

  def log_update
    message = "#{get_current_user_name} edited the commune details."
    long_message = ""
    if self.name_changed?
      long_message = long_message + "Old name: #{self.name_was}, new name: #{self.name}"
    end
    if self.description_changed?
      long_message = long_message + "Old description: '#{self.description_was}', new description '#{self.description}'"
    end
    CommuneLog.create(commune_id: self.id, message: message, long_message: long_message)
  end

  def get_current_user_name
    if defined?(current_user)
      return  current_user.name
    else
      return ""
    end
  end
end
