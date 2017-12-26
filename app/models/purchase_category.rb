class PurchaseCategory < ApplicationRecord
  validates_presence_of :name
  has_many :purchases
  belongs_to :commune

end
