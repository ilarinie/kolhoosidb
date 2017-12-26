class Purchase < ApplicationRecord
  validates :amount, :presence => true, :numericality => true
  validates_numericality_of :amount, less_than_or_equal_to: 100000000, greater_than: -100000000
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user}, recipient: Proc.new{ |controller, model| controller.find_commune_and_check_if_user }
  belongs_to :commune
  belongs_to :purchase_category
  belongs_to :user



end
