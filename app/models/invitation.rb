class Invitation < ApplicationRecord
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user}, recipient: Proc.new{ |controller, model| controller.find_commune_and_check_if_admin }
  belongs_to :commune
  belongs_to :user

  validates_uniqueness_of :user_id, scope: %i[commune_id]
end
