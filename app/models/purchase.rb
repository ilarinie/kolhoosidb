class Purchase < ApplicationRecord
belongs_to :commune
  belongs_to :purchase_category
end
