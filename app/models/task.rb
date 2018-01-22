class Task < ApplicationRecord
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user},
          recipient: Proc.new{ |controller, model| controller.find_commune_and_check_if_admin },
          params: {  "target_description" => proc { |controller, model| model.name },
                     "additional_information" => proc { |controller, model| "Points: " + model.reward.to_s + ", priority: " + model.priority.to_s + " hours."}}
  belongs_to :commune
  has_many :task_completions

  validates_presence_of :name
  validates :name, length: { in: 2..35 }

  def get_last_completions
    TaskCompletion.where(task_id: self.id).includes(:user).last(10).reverse!
  end

end
