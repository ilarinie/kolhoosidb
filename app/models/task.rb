class Task < ApplicationRecord
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user}, recipient: Proc.new{ |controller, model| controller.find_commune_and_check_if_admin }
  belongs_to :commune
  has_many :task_completions

  validates_presence_of :name

  def get_last_completions
    TaskCompletion.where(task_id: self.id).includes(:user).last(10).reverse!
  end

end
