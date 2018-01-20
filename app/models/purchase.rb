class Purchase < ApplicationRecord
  belongs_to :commune
  belongs_to :purchase_category
  belongs_to :user

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user},
          recipient: Proc.new{ |controller, model| controller.find_commune_and_check_if_user },
          params: { "target_description" => proc { |controller, model| model.description }, "additional_information" => proc { |controller, model| model.amount.to_s }}


  validates :amount, :presence => true, :numericality => true
  validates_numericality_of :amount, less_than_or_equal_to: 100000000, greater_than: -100000000


end
