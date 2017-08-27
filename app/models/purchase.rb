class Purchase < ApplicationRecord
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user}, recipient: Proc.new{ |controller, model| controller.find_commune_and_check_if_user }
  belongs_to :commune
  belongs_to :purchase_category
  belongs_to :user



end
