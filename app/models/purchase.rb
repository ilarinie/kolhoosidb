class Purchase < ApplicationRecord
  validates :amount, :presence => true, :numericality => true
  validates_numericality_of :amount, less_than_or_equal_to: 100000000, greater_than: -100000000
 # include PublicActivity::Model
 # tracked owner: Proc.new{ |controller, model| controller.current_user}, recipient: Proc.new{ |controller, model| controller.find_commune_and_check_if_user }
  belongs_to :commune
  belongs_to :purchase_category
  belongs_to :user
  after_create :log_create, on: [:create]
  after_update :log_update, on: [:update]
  after_destroy :log_destroy, on: [:destroy]

  def log_create
    message = "#{self.user.name} made a purchase."
    long_message ="#{self.description} (#{self.purchase_category.name}) #{self.amount.to_s} €"
    CommuneLog.create(commune_id: self.commune_id, message: message, long_message: long_message)
  end

  def log_update
    byebug
    message = "#{self.user.name} edited a purchase."
    long_message = ""
    if self.description_changed?
      long_message = long_message + "Description => old: #{self.description_was}, new: #{self.description}. "
    end
    if self.amount_changed?
      long_message = long_message + "Amount => old: #{self.amount_was}, new: #{self.amount}. "
    end
    if self.purchase_category_id_changed?
      long_message = long_message + "Category: #{self.purchase_category_was.name} => #{self.purchase_category.name}"
    end
    CommuneLog.create(commune_id: self.commune_id, message: message, long_message: long_message)
  end

  def log_destroy
    byebug
    message = "#{self.user.name} deleted a purchase."
    long_message = "#{self.description}  #{self.amount.to_s} €, at #{self.created_at.strftime("%d.%m.%Y")}"
    CommuneLog.create(commune_id:self.commune_id, message: message, long_message: long_message)
  end
end
