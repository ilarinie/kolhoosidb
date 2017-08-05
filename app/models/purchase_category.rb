class PurchaseCategory < ApplicationRecord
  has_many :purchases
  belongs_to :commune

end
